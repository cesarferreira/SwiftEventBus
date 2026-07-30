# SwiftEventBus

[![CI](https://github.com/cesarferreira/SwiftEventBus/actions/workflows/ci.yml/badge.svg)](https://github.com/cesarferreira/SwiftEventBus/actions/workflows/ci.yml)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20PM-compatible-brightgreen.svg)](Package.swift)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-brightgreen.svg)](https://cocoapods.org/pods/SwiftEventBus)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![Swift 5](https://img.shields.io/badge/Swift-5-green.svg?style=flat)](https://swift.org)

Allows publish-subscribe-style communication between components without requiring the components to explicitly be aware of each other.

## Features

- [x] simplifies the communication between components
- [x] decouples event senders and receivers
- [x] avoids complex and error-prone dependencies and life cycle issues
- [x] makes your code simpler
- [x] is fast
- [x] is tiny
- [x] Thread-safe
- [x] iOS, macOS, tvOS, and watchOS (Swift Package Manager)

## Installation

### Swift Package Manager

In Xcode: **File → Add Package Dependencies…** and enter:

```
https://github.com/cesarferreira/SwiftEventBus.git
```

Or add to your `Package.swift`:

```swift
.package(url: "https://github.com/cesarferreira/SwiftEventBus.git", from: "5.2.0")
```

### CocoaPods

```bash
pod 'SwiftEventBus', '~> 5.2'
```

Or pin a release:

```bash
pod 'SwiftEventBus', :tag => '5.2.0', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'
```

### Carthage

```bash
github "cesarferreira/SwiftEventBus" ~> 5.2
```

### Versions

- `5.2.+` — Swift 5, iOS 12+, macOS 10.15+, tvOS 12+, watchOS 6+
- `5.+` — Swift 5
- `3.+` — Swift 4.2
- `2.+` — Swift 3
- `1.1.0` — Swift 2.2

## macOS

SwiftEventBus is **Foundation-only** (no UIKit), so it works on **macOS 10.15+** with the same API as on iOS.

**Recommended:** add the package in Xcode (**File → Add Package Dependencies…**) or depend on it from your app's `Package.swift` (see above). CI builds and tests the library on macOS on every push.

**CocoaPods** on Mac:

```bash
pod 'SwiftEventBus', '~> 5.2'
```

Example in an `NSViewController` subclass:

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

The **Sample** app in this repo is iOS-only (storyboard demo). For Mac apps, integrate via Swift Package Manager or CocoaPods as above.

## Usage

### 1 — Prepare subscribers

Subscribers implement event handling methods that will be called when an event is received.

```swift
SwiftEventBus.onMainThread(target, name: "someEventName") { result in
    // UI thread
}

// or

SwiftEventBus.onBackgroundThread(target, name: "someEventName") { result in
    // API access
}
```

### 2 — Post events

Post an event from any part of your code. All subscribers matching the event type will receive it.

```swift
SwiftEventBus.post("someEventName")
```

---

### Event bus with parameters

Post event:

```swift
SwiftEventBus.post("personFetchEvent", sender: Person(name: "john doe"))
```

Expecting parameters:

```swift
SwiftEventBus.onMainThread(target, name: "personFetchEvent") { result in
    let person = result?.object as! Person
    print(person.name) // will output "john doe"
}
```

### Posting events from the background thread to the main thread

Quoting the official Apple [documentation](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Notifications/Articles/Threading.html):

> Regular notification centers deliver notifications on the thread in which the notification was posted

Regarding this limitation, [@nunogoncalves](https://github.com/nunogoncalves) implemented the feature and provided a working example:

```swift
@IBAction func clicked(sender: AnyObject) {
    count += 1
    SwiftEventBus.post("doStuffOnBackground")
}

@IBOutlet weak var textField: UITextField!

var count = 0

override func viewDidLoad() {
    super.viewDidLoad()

    SwiftEventBus.onBackgroundThread(self, name: "doStuffOnBackground") { _ in
        print("doing stuff in background thread")
        SwiftEventBus.postToMainThread("updateText")
    }

    SwiftEventBus.onMainThread(self, name: "updateText") { _ in
        self.textField.text = "\(self.count)"
    }
}

// Perhaps on viewDidDisappear depending on your needs
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    SwiftEventBus.unregister(self)
}
```

---

## Unregistering

Remove all the observers from the target:

```swift
SwiftEventBus.unregister(target)
```

Remove observers of the same name from the target:

```swift
SwiftEventBus.unregister(target, name: "someEventName")
```
