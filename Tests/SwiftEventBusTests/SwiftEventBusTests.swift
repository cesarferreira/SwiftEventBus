import XCTest
@testable import SwiftEventBus

final class SwiftEventBusTests: XCTestCase {
    private final class Target: NSObject {}

    private var targets: [NSObject] = []

    override func tearDown() {
        for target in targets {
            SwiftEventBus.unregister(target)
        }
        targets.removeAll()
        super.tearDown()
    }

    private func track<T: NSObject>(_ target: T) -> T {
        targets.append(target)
        return target
    }

    // MARK: - Post / subscribe

    func testPostDeliversToBackgroundSubscriber() {
        let target = track(Target())
        let expectation = expectation(description: "event received")

        SwiftEventBus.onBackgroundThread(target, name: "testEvent") { _ in
            expectation.fulfill()
        }

        SwiftEventBus.post("testEvent")
        waitForExpectations(timeout: 2)
    }

    func testPostDeliversSenderObject() {
        let target = track(Target())
        let payload = NSObject()
        let expectation = expectation(description: "sender delivered")

        SwiftEventBus.onBackgroundThread(target, name: "payloadEvent") { notification in
            XCTAssertIdentical(notification?.object as AnyObject?, payload)
            expectation.fulfill()
        }

        SwiftEventBus.post("payloadEvent", sender: payload)
        waitForExpectations(timeout: 2)
    }

    func testPostWithUserInfo() {
        let target = track(Target())
        let expectation = expectation(description: "userInfo delivered")

        SwiftEventBus.onBackgroundThread(target, name: "infoEvent") { notification in
            XCTAssertEqual(notification?.userInfo?["key"] as? String, "value")
            expectation.fulfill()
        }

        SwiftEventBus.post("infoEvent", sender: nil, userInfo: ["key": "value"])
        waitForExpectations(timeout: 2)
    }

    func testOnFiltersBySenderObject() {
        let target = track(Target())
        let expectedSender = NSObject()
        let otherSender = NSObject()
        let expectation = expectation(description: "matching sender only")
        expectation.expectedFulfillmentCount = 1

        SwiftEventBus.onBackgroundThread(target, name: "senderFilter", sender: expectedSender) { _ in
            expectation.fulfill()
        }

        SwiftEventBus.post("senderFilter", sender: otherSender)
        SwiftEventBus.post("senderFilter", sender: expectedSender)
        waitForExpectations(timeout: 2)
    }

    func testMultipleSubscribersReceiveSameEvent() {
        let firstTarget = track(Target())
        let secondTarget = track(Target())
        let first = expectation(description: "first subscriber")
        let second = expectation(description: "second subscriber")

        SwiftEventBus.onBackgroundThread(firstTarget, name: "broadcast") { _ in first.fulfill() }
        SwiftEventBus.onBackgroundThread(secondTarget, name: "broadcast") { _ in second.fulfill() }

        SwiftEventBus.post("broadcast")
        waitForExpectations(timeout: 2)
    }

    func testCustomQueueDelivery() {
        let target = track(Target())
        let queue = OperationQueue()
        let expectation = expectation(description: "custom queue")

        SwiftEventBus.on(target, name: "customQueue", sender: nil, queue: queue) { _ in
            expectation.fulfill()
        }

        SwiftEventBus.post("customQueue")
        waitForExpectations(timeout: 2)
    }

    // MARK: - Main thread

    func testPostToMainThreadDispatchesOnMainQueue() {
        let target = track(Target())
        let expectation = expectation(description: "main thread delivery")

        SwiftEventBus.onMainThread(target, name: "mainEvent") { _ in
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }

        SwiftEventBus.postToMainThread("mainEvent")
        waitForExpectations(timeout: 2)
    }

    func testPostToMainThreadWithUserInfo() {
        let target = track(Target())
        let expectation = expectation(description: "main thread userInfo")

        SwiftEventBus.onMainThread(target, name: "mainInfo") { notification in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(notification?.userInfo?["count"] as? Int, 42)
            expectation.fulfill()
        }

        SwiftEventBus.postToMainThread("mainInfo", sender: nil, userInfo: ["count": 42])
        waitForExpectations(timeout: 2)
    }

    func testOnMainThreadWhenPostedFromBackgroundQueue() {
        let target = track(Target())
        let expectation = expectation(description: "main handler from bg post")

        SwiftEventBus.onMainThread(target, name: "bgToMain") { _ in
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }

        DispatchQueue.global(qos: .userInitiated).async {
            SwiftEventBus.post("bgToMain")
        }

        waitForExpectations(timeout: 2)
    }

    // MARK: - Unregister

    func testUnregisterByNameRemovesMatchingObserverOnly() {
        let target = track(Target())
        let keep = expectation(description: "keep")
        let remove = expectation(description: "remove")
        remove.isInverted = true

        SwiftEventBus.onBackgroundThread(target, name: "keep") { _ in keep.fulfill() }
        SwiftEventBus.onBackgroundThread(target, name: "remove") { _ in remove.fulfill() }

        SwiftEventBus.unregister(target, name: "remove")
        SwiftEventBus.post("remove")
        SwiftEventBus.post("keep")

        waitForExpectations(timeout: 2)
    }

    func testUnregisterAllStopsFurtherDelivery() {
        final class Counter: NSObject {
            var value = 0
        }

        let counter = track(Counter())

        SwiftEventBus.onBackgroundThread(counter, name: "stop") { _ in
            counter.value += 1
        }

        SwiftEventBus.post("stop")
        waitForBackgroundHandlers()
        XCTAssertEqual(counter.value, 1)

        SwiftEventBus.unregister(counter)
        SwiftEventBus.post("stop")
        waitForBackgroundHandlers()
        XCTAssertEqual(counter.value, 1)
    }

    func testUnregisterClearsInternalCacheEntry() {
        let target = track(Target())
        SwiftEventBus.onBackgroundThread(target, name: "cache") { _ in }

        let id = UInt(bitPattern: ObjectIdentifier(target))
        XCTAssertNotNil(SwiftEventBus.Static.instance.cache[id])

        SwiftEventBus.unregister(target)
        XCTAssertNil(SwiftEventBus.Static.instance.cache[id])
    }

    func testDuplicateRegistrationReceivesMultipleTimes() {
        let target = track(Target())
        let expectation = expectation(description: "duplicate handlers")
        expectation.expectedFulfillmentCount = 2

        SwiftEventBus.onBackgroundThread(target, name: "dup") { _ in expectation.fulfill() }
        SwiftEventBus.onBackgroundThread(target, name: "dup") { _ in expectation.fulfill() }

        SwiftEventBus.post("dup")
        waitForExpectations(timeout: 2)
    }

    // MARK: - Concurrency

    func testConcurrentRegistrationDoesNotCrash() {
        let target = track(Target())
        let group = DispatchGroup()

        for index in 0..<32 {
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                SwiftEventBus.onBackgroundThread(target, name: "concurrent-\(index)") { _ in }
                group.leave()
            }
        }

        let registrationsFinished = expectation(description: "registrations")
        DispatchQueue.global(qos: .userInitiated).async {
            group.wait()
            registrationsFinished.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    private func waitForBackgroundHandlers() {
        let done = expectation(description: "background queue drain")
        DispatchQueue.global(qos: .userInitiated).async {
            done.fulfill()
        }
        wait(for: [done], timeout: 2)
    }
}
