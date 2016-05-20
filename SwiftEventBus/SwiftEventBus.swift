import Foundation

public protocol NameCompatible {
    var seb_name: String { get }
}

extension String: NameCompatible {
    public var seb_name: String {
        return self
    }
}

public class SwiftEventBus {
    
    struct Static {
        static let instance = SwiftEventBus()
        static let queue = dispatch_queue_create("com.cesarferreira.SwiftEventBus", DISPATCH_QUEUE_SERIAL)
    }
    
    struct NamedObserver {
        let observer: NSObjectProtocol
        let name: NameCompatible
    }
    
    var cache = [UInt:[NamedObserver]]()
    
    
    ////////////////////////////////////
    // Publish
    ////////////////////////////////////
    
    public class func post(name: NameCompatible) {
        NSNotificationCenter.defaultCenter().postNotificationName(name.seb_name, object: nil)
    }
    
    public class func post(name: NameCompatible, sender: AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name.seb_name, object: sender)
    }
    
    public class func post(name: NameCompatible, sender: NSObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name.seb_name, object: sender)
    }
    
    public class func post(name: NameCompatible, userInfo: [NSObject : AnyObject]?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name.seb_name, object: nil, userInfo: userInfo)
    }
    
    public class func post(name: NameCompatible, sender: AnyObject?, userInfo: [NSObject : AnyObject]?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name.seb_name, object: sender, userInfo: userInfo)
    }
    
    public class func postToMainThread(name: NameCompatible) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(name.seb_name, object: nil)
        }
    }
    
    public class func postToMainThread(name: NameCompatible, sender: AnyObject?) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(name.seb_name, object: sender)
        }
    }
    
    public class func postToMainThread(name: NameCompatible, sender: NSObject?) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(name.seb_name, object: sender)
        }
    }
    
    public class func postToMainThread(name: NameCompatible, userInfo: [NSObject : AnyObject]?) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(name.seb_name, object: nil, userInfo: userInfo)
        }
    }
    
    public class func postToMainThread(name: NameCompatible, sender: AnyObject?, userInfo: [NSObject : AnyObject]?) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(name.seb_name, object: sender, userInfo: userInfo)
        }
    }
    

    
    ////////////////////////////////////
    // Subscribe
    ////////////////////////////////////
    
    public class func on(target: AnyObject, name: NameCompatible, sender: AnyObject?, queue: NSOperationQueue?, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        let id = ObjectIdentifier(target).uintValue
        let observer = NSNotificationCenter.defaultCenter().addObserverForName(name.seb_name, object: sender, queue: queue, usingBlock: handler)
        let namedObserver = NamedObserver(observer: observer, name: name)
        
        dispatch_sync(Static.queue) {
            if let namedObservers = Static.instance.cache[id] {
                Static.instance.cache[id] = namedObservers + [namedObserver]
            } else {
                Static.instance.cache[id] = [namedObserver]
            }
        }
        
        return observer
    }
    
    public class func onMainThread(target: AnyObject, name: NameCompatible, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: nil, queue: NSOperationQueue.mainQueue(), handler: handler)
    }
    
    public class func onMainThread(target: AnyObject, name: NameCompatible, sender: AnyObject?, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: sender, queue: NSOperationQueue.mainQueue(), handler: handler)
    }
    
    public class func onBackgroundThread(target: AnyObject, name: NameCompatible, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: nil, queue: NSOperationQueue(), handler: handler)
    }
    
    public class func onBackgroundThread(target: AnyObject, name: NameCompatible, sender: AnyObject?, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: sender, queue: NSOperationQueue(), handler: handler)
    }
    
    ////////////////////////////////////
    // Unregister
    ////////////////////////////////////
    
    public class func unregister(target: AnyObject) {
        let id = ObjectIdentifier(target).uintValue
        let center = NSNotificationCenter.defaultCenter()
        
        dispatch_sync(Static.queue) {
            if let namedObservers = Static.instance.cache.removeValueForKey(id) {
                for namedObserver in namedObservers {
                    center.removeObserver(namedObserver.observer)
                }
            }
        }
    }
    
    public class func unregister(target: AnyObject, name: NameCompatible) {
        let id = ObjectIdentifier(target).uintValue
        let center = NSNotificationCenter.defaultCenter()
        
        dispatch_sync(Static.queue) {
            if let namedObservers = Static.instance.cache[id] {
                Static.instance.cache[id] = namedObservers.filter({ (namedObserver: NamedObserver) -> Bool in
                    if namedObserver.name.seb_name == name.seb_name {
                        center.removeObserver(namedObserver.observer)
                        return false
                    } else {
                        return true
                    }
                })
            }
        }
    }
    
}
