# SwiftEventBus

Provides an interface for use the `addObserverForName` safely and easily.

## Features

- [x] simplifies the communication between components
- [x] decouples event senders and receivers
- [x] avoids complex and error-prone dependencies and life cycle issues
- [x] makes your code simpler
- [x] is fast
- [x] is tiny
- [x] Thread-safe


## Requirements

- iOS 8+
- Xcode 6.1

## Installation

```bash
pod 'SwiftEventBus', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'
```

## Usage
### 1: Prepare subscribers ###

Subscribers implement event handling methods that will be called when an event is received.

```swift
EventBus.onMainThread(target, name: "someEventName") { result in
    // UI thread
}

// or

EventBus.onBackgroundThread(target, name:"someEventName") { result in
    // API Access
}
```

### 2: Post events ###

Post an event from any part of your code. All subscribers matching the event type will receive it.

```swift
EventBus.post("someEventName")
```

### Eventbus with parameters

Post event

```swift
EventBus.post("personFetchEvent", sender: Person(name:"john doe"))
```

Expecting parameters
```swift
EventBus.onMainThread(target, name:"personFetchEvent") { result in
    let person : Person = result.object as Person
    println(person.name) // will output "john doe"
}
```

## Unregistering

Remove all the observers of the target
```swift
EventBus.unregister(target)
```
Remove observers of the same name of the target
```swift
EventBus.unregister(target, "someEventName")
```
