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

### Cocoapods

```bash
pod 'SwiftEventBus', :tag => '5.0.0', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'
```

### Carthage
```bash
github "cesarferreira/SwiftEventBus" == 5.0.0
```

### Versions

- `5.+` for `swift 5`
- `3.+` for `swift 4.2`
- `2.+` for `swift 3`
- `1.1.0` for `swift 2.2`

## Usage
### 1 - Prepare subscribers ###

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

### 2 - Post events ###

Post an event from any part of your code. All subscribers matching the event type will receive it.

```swift
SwiftEventBus.post("someEventName")
```

--

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

### Posting events from the BackgroundThread to the MainThread

Quoting the official Apple [documentation](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Notifications/Articles/Threading.html):
> Regular notification centers deliver notifications on the thread in which the notification was posted


Regarding this limitation, [@nunogoncalves](https://github.com/nunogoncalves) implemented the feature and provided a working example:

```swift

@IBAction func clicked(sender: AnyObject) {
     count++
     SwiftEventBus.post("doStuffOnBackground")
 }

 @IBOutlet weak var textField: UITextField!

 var count = 0

 override func viewDidLoad() {
     super.viewDidLoad()

     SwiftEventBus.onBackgroundThread(self, name: "doStuffOnBackground") { notification in
         println("doing stuff in background thread")
         SwiftEventBus.postToMainThread("updateText")
     }

     SwiftEventBus.onMainThread(self, name: "updateText") { notification in
         self.textField.text = "\(self.count)"
     }
}

//Perhaps on viewDidDisappear depending on your needs
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    SwiftEventBus.unregister(self)
}
```
--


## Unregistering

Remove all the observers from the target
```swift
SwiftEventBus.unregister(target)
```
Remove observers of the same name from the target
```swift
SwiftEventBus.unregister(target, "someEventName")
```
