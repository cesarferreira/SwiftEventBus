import XCTest
@testable import SwiftEventBus

final class SwiftEventBusTests: XCTestCase {
    private final class Target: NSObject {}

    func testPostDeliversToBackgroundSubscriber() {
        let target = Target()
        let expectation = expectation(description: "event received")

        SwiftEventBus.onBackgroundThread(target, name: "testEvent") { _ in
            expectation.fulfill()
        }

        SwiftEventBus.post("testEvent")
        waitForExpectations(timeout: 2)
        SwiftEventBus.unregister(target)
    }

    func testUnregisterByNameRemovesMatchingObserverOnly() {
        let target = Target()
        let keep = expectation(description: "keep")
        let remove = expectation(description: "remove")
        remove.isInverted = true

        SwiftEventBus.onBackgroundThread(target, name: "keep") { _ in
            keep.fulfill()
        }
        SwiftEventBus.onBackgroundThread(target, name: "remove") { _ in
            remove.fulfill()
        }

        SwiftEventBus.unregister(target, name: "remove")
        SwiftEventBus.post("remove")
        SwiftEventBus.post("keep")

        waitForExpectations(timeout: 2)
        SwiftEventBus.unregister(target)
    }

    func testPostToMainThreadDispatchesOnMainQueue() {
        let target = Target()
        let expectation = expectation(description: "main thread delivery")

        SwiftEventBus.onMainThread(target, name: "mainEvent") { _ in
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }

        SwiftEventBus.postToMainThread("mainEvent")
        waitForExpectations(timeout: 2)
        SwiftEventBus.unregister(target)
    }
}
