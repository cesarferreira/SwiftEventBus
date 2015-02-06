# swift-EventBus

Provides an interface for use the `addObserverForName` safely and easily.

## Features

- [x] Thread-safe

## Requirements

- iOS 8+
- Xcode 6.1

## Installation

// todo

## Usage

### Minimum

```swift
EventBus.onMainThread(target, name: "someEventName") { result in
    // UI thread
}

EventBus.onBackgroundThread(target, name:"someEventName") { result in
    // API Access
}

EventBus.post("someEventName")

EventBus.unregister(target) // Remove all the observers of the target

EventBus.unregister(target, "someEventName") // Remove observers of the same name of the target
```

### Sender

```swift
EventBus.onMainThread(target, name:"personFetchEvent") { result in
    // API Access
    let person = result.object as Person
}

let person = Person(name:"john doe")
EventBus.post("personFetchEvent", sender: person)
```
