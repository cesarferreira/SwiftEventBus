# SwiftEventBus

Allows publish-subscribe-style communication between components without requiring the components to explicitly be aware of each other

## Features

- [x] simplifies the communication between components
- [x] decouples event senders and receivers
- [x] avoids complex and error-prone dependencies and life cycle issues
- [x] makes your code simpler
- [x] is fast
- [x] is tiny
- [x] Thread-safe

## Installation

```bash
pod 'SwiftEventBus', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'
```

## Usage
### 1: Prepare subscribers ###

Subscribers implement event handling methods that will be called when an event is received.

```swift
SwiftEventBus.onMainThread(target, name: "someEventName") { result in
    // UI thread
}

// or

SwiftEventBus.onBackgroundThread(target, name:"someEventName") { result in
    // API Access
}
```

### 2: Post events ###

Post an event from any part of your code. All subscribers matching the event type will receive it.

```swift
SwiftEventBus.post("someEventName")
```

### Eventbus with parameters

Post event

```swift
SwiftEventBus.post("personFetchEvent", sender: Person(name:"john doe"))
```

Expecting parameters
```swift
SwiftEventBus.onMainThread(target, name:"personFetchEvent") { result in
    let person : Person = result.object as Person
    println(person.name) // will output "john doe"
}
```

## Unregistering

Remove all the observers from the target
```swift
SwiftEventBus.unregister(target)
```
Remove observers of the same name from the target
```swift
SwiftEventBus.unregister(target, "someEventName")
```
