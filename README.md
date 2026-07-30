<p align="center">
  <h1 align="center">SwiftEventBus</h1>
  <p align="center">
    A tiny, thread-safe publish/subscribe bus for Apple platforms — decouple components without wiring delegates everywhere.
  </p>
  <p align="center">
    <a href="https://github.com/cesarferreira/SwiftEventBus/actions/workflows/ci.yml"><img src="https://github.com/cesarferreira/SwiftEventBus/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
    <a href="Package.swift"><img src="https://img.shields.io/badge/Swift%20PM-compatible-brightgreen.svg" alt="Swift PM"></a>
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License">
    <img src="https://img.shields.io/badge/Swift-5-green.svg?style=flat" alt="Swift 5">
  </p>
  <p align="center">
    <a href="#install">Install</a>
    &nbsp;·&nbsp;
    <a href="#quickstart">Quickstart</a>
    &nbsp;·&nbsp;
    <a href="#highlights">Highlights</a>
    &nbsp;·&nbsp;
    <a href="#api">API</a>
    &nbsp;·&nbsp;
    <a href="#platforms">Platforms</a>
  </p>
</p>

---

## Why SwiftEventBus

NotificationCenter is built in, but stringly-typed observers, thread hops, and lifecycle cleanup get messy fast. **SwiftEventBus** wraps the same primitives with a small API: register on a target, post by name, unregister when the target goes away.

- **Decouple senders and receivers.** Components talk through event names, not direct references.
- **Thread-aware delivery.** `onMainThread`, `onBackgroundThread`, or a custom `OperationQueue`.
- **Main-thread posting.** `postToMainThread` when work finishes off the UI queue.
- **Lifecycle-friendly.** Track observers per target; `unregister(_:)` tears them down in one call.
- **Foundation-only.** No UIKit in the library — same API on iOS, macOS, tvOS, and watchOS via **Swift Package Manager**.
- **Battle-tested.** Built on `NotificationCenter`; registration cache is guarded for concurrent use.

## Quickstart

Add the package in Xcode (**File → Add Package Dependencies…**):

```
https://github.com/cesarferreira/SwiftEventBus.git
```

Then wire a subscriber and post an event:

```swift
import SwiftEventBus

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftEventBus.onMainThread(self, name: "profileUpdated") { notification in
            self.refreshUI(with: notification?.object)
        }
    }

    func saveProfile() {
        SwiftEventBus.post("profileUpdated", sender: currentUser)
    }

    deinit {
        SwiftEventBus.unregister(self)
    }
}
```

**Rule of thumb:** pass `self` (or another long-lived object) as the registration target and call `unregister` when that object is done — typically `deinit` or `viewWillDisappear`.

## Install

SwiftEventBus is distributed as a **Swift package**. That is the supported integration path for new apps and libraries.

### Xcode

1. **File → Add Package Dependencies…**
2. Enter `https://github.com/cesarferreira/SwiftEventBus.git`
3. Choose **Up to Next Major** from `5.3.0` (or a newer release tag)
4. Add the **SwiftEventBus** product to your app or framework target

### Package.swift

Add the dependency to your package manifest:

```swift
dependencies: [
    .package(url: "https://github.com/cesarferreira/SwiftEventBus.git", from: "5.3.0"),
],
targets: [
    .target(
        name: "MyApp",
        dependencies: ["SwiftEventBus"]
    ),
]
```

Pin an exact version when you need reproducible builds:

```swift
.package(url: "https://github.com/cesarferreira/SwiftEventBus.git", exact: "5.3.0"),
```

### Command line

From an existing Swift package directory:

```bash
swift package resolve
swift build
swift test   # when developing against a local checkout of this repo
```

### Platforms (SPM)

| Release | Swift | Minimum OS |
| ------- | ----- | ---------- |
| `5.3.+` | 5     | iOS 12, macOS 10.15, tvOS 12, watchOS 6 |
| `5.2.+` | 5     | Same platform mins; prefer `5.3.+` for macOS Xcode framework fixes |
| `5.+`   | 5     | See `Package.swift` `platforms` for the tag you pin |
| Older tags | 2–4 | Legacy; not recommended for new projects |

### Legacy integrators

[CocoaPods](https://cocoapods.org/) and [Carthage](https://github.com/Carthage/Carthage) are **not** actively maintained for this project anymore. The last published podspec (`SwiftEventBus.podspec`) and Xcode framework target remain in the repo for existing users, but new work should use SPM above.

## Highlights

### Payloads and filtering

Attach a sender object or `userInfo` like any notification:

```swift
SwiftEventBus.post("personFetched", sender: person)
SwiftEventBus.post("syncProgress", sender: nil, userInfo: ["percent": 42])

SwiftEventBus.onMainThread(self, name: "personFetched") { note in
    let person = note?.object as! Person
    print(person.name)
}
```

Register with a specific `sender` to only receive posts that use the same object:

```swift
SwiftEventBus.onBackgroundThread(self, name: "jobDone", sender: jobID) { _ in
    // only fires when post(..., sender: jobID) matches
}
```

### Background work → main UI

`NotificationCenter` delivers on the thread where you post. For UI updates, hop explicitly:

```swift
SwiftEventBus.onBackgroundThread(self, name: "fetchData") { _ in
    let result = loadFromNetwork()
    SwiftEventBus.postToMainThread("fetchDataDone", sender: result)
}

SwiftEventBus.onMainThread(self, name: "fetchDataDone") { note in
    self.apply(result: note?.object)
}
```

Credit for the original pattern: [@nunogoncalves](https://github.com/nunogoncalves).

### macOS

Add the package in Xcode or your `Package.swift` (see [Install](#install)). Example with AppKit:

```swift
import AppKit
import SwiftEventBus

final class MainViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftEventBus.onMainThread(self, name: "refresh") { _ in
            self.view.needsLayout = true
        }
    }

    deinit {
        SwiftEventBus.unregister(self)
    }
}
```

The **Sample** target in this repo is an iOS storyboard demo only; Mac apps should add the Swift package dependency.

## API

### Subscribe

| Method | Delivery |
| ------ | -------- |
| `onMainThread(_:name:sender:handler:)` | `OperationQueue.main` |
| `onBackgroundThread(_:name:sender:handler:)` | Background `OperationQueue` |
| `on(_:name:sender:queue:handler:)` | Custom queue |

Handlers receive `(Notification?) -> Void`. Registration returns an observer token (usually you rely on `unregister` instead).

### Post

| Method | Behavior |
| ------ | -------- |
| `post(_:sender:)` | Post on the current thread |
| `post(_:sender:userInfo:)` | Post with dictionary payload |
| `postToMainThread(_:sender:)` | Async dispatch to main, then post |
| `postToMainThread(_:sender:userInfo:)` | Same, with `userInfo` |

### Unregister

```swift
SwiftEventBus.unregister(target)              // all events for target
SwiftEventBus.unregister(target, name: "x")   // one event name for target
```

## Platforms

SwiftEventBus is tested on every push via [GitHub Actions](https://github.com/cesarferreira/SwiftEventBus/actions):

| Job | What it verifies |
| --- | ---------------- |
| **macOS (Swift Package Manager)** | `swift build` / `swift test` on macOS (14 unit tests) |
| **macOS (Xcode framework)** | Framework build for `generic/platform=macOS` |
| **iOS (Xcode framework)** | Framework build for iOS |
| **Sample iOS app** | Sample app build, Simulator launch, smoke event path |

**Requirements:** Swift 5, Xcode 15+ recommended for local development.

## Sample app

Open `SwiftEventBus.xcodeproj`, run the **Sample** scheme on an iOS Simulator. It exercises login flow events (`loginCall` → background work → `login` on the main thread). CI launches Sample with `-SmokeTest` to assert the bus end-to-end.

## Contributing

Issues and PRs welcome. Please keep changes focused; CI must stay green.

1. Fork and branch from `master`
2. Run tests locally: `swift test` (macOS or Linux Docker with Swift 5.10+)
3. Open a PR — the workflow runs SPM, iOS/macOS framework builds, and the Sample smoke test

## License

[MIT](LICENSE) © César Ferreira
