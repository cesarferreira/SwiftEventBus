//
//  JSONHelper.swift
//
//  Created by Baris Sencan on 28/08/2014.
//  Copyright 2014 Baris Sencan
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/isair/JSONHelper
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

import Foundation

/// A type of dictionary that only uses strings for keys and can contain any
/// type of object as a value.
public typealias JSONDictionary = [String: AnyObject]

/// Operator for use in deserialization operations.
infix operator <-- { associativity right precedence 150 }

/// MARK: Primitive Type Deserialization

// For optionals.
public func <-- <T>(inout property: T?, value: AnyObject?) -> T? {
  var newValue: T?
  if let unwrappedValue: AnyObject = value {
    // We unwrapped the given value successfully, try to convert.
    if let convertedValue = unwrappedValue as? T {
      // Convert by just type-casting.
      newValue = convertedValue
    } else {
      // Convert by processing the value first.
      switch property {
      case is Int?:
        if unwrappedValue is String {
          if let intValue = "\(unwrappedValue)".toInt() {
            newValue = intValue as? T
          }
        }
      case is NSURL?:
        newValue = NSURL(string: "\(unwrappedValue)") as? T
      case is NSDate?:
        if let timestamp = value as? Int {
          newValue = NSDate(timeIntervalSince1970: Double(timestamp)) as? T
        } else if let timestamp = value as? Double {
          newValue = NSDate(timeIntervalSince1970: timestamp) as? T
        } else if let timestamp = value as? NSNumber {
          newValue = NSDate(timeIntervalSince1970: timestamp.doubleValue) as? T
        }
      default:
        break
      }
    }
  }
  property = newValue
  return property
}

// For non-optionals.
public func <-- <T>(inout property: T, value: AnyObject?) -> T {
  var newValue: T?
  newValue <-- value
  if let newValue = newValue { property = newValue }
  return property
}

// Special handling for value and format pair to NSDate conversion.
public func <-- (inout property: NSDate?, valueAndFormat: (value: AnyObject?, format: AnyObject?)) -> NSDate? {
  var newValue: NSDate?
  if let dateString = valueAndFormat.value as? String {
    if let formatString = valueAndFormat.format as? String {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = formatString
      if let newDate = dateFormatter.dateFromString(dateString) {
        newValue = newDate
      }
    }
  }
  property = newValue
  return property
}

public func <-- (inout property: NSDate, valueAndFormat: (value: AnyObject?, format: AnyObject?)) -> NSDate {
  var date: NSDate?
  date <-- valueAndFormat
  if let date = date { property = date }
  return property
}

// MARK: Primitive Array Deserialization

public func <-- (inout array: [String]?, value: AnyObject?) -> [String]? {
  if let stringArray = value as? [String] {
    array = stringArray
  } else {
    array = nil
  }
  return array
}

public func <-- (inout array: [String], value: AnyObject?) -> [String] {
  var newValue: [String]?
  newValue <-- value
  if let newValue = newValue { array = newValue }
  return array
}

public func <-- (inout array: [Int]?, value: AnyObject?) -> [Int]? {
  if let intArray = value as? [Int] {
    array = intArray
  } else {
    array = nil
  }
  return array
}

public func <-- (inout array: [Int], value: AnyObject?) -> [Int] {
  var newValue: [Int]?
  newValue <-- value
  if let newValue = newValue { array = newValue }
  return array
}

public func <-- (inout array: [Float]?, value: AnyObject?) -> [Float]? {

  if let floatArray = value as? [Float] {
    array = floatArray
  } else {
    array = nil
  }
  return array
}

public func <-- (inout array: [Float], value: AnyObject?) -> [Float] {
  var newValue: [Float]?
  newValue <-- value
  if let newValue = newValue { array = newValue }
  return array
}

public func <-- (inout array: [Double]?, value: AnyObject?) -> [Double]? {
  if let doubleArrayDoubleExcitement = value as? [Double] {
    array = doubleArrayDoubleExcitement
  } else {
    array = nil
  }
  return array
}

public func <-- (inout array: [Double], value: AnyObject?) -> [Double] {
  var newValue: [Double]?
  newValue <-- value
  if let newValue = newValue { array = newValue }
  return array
}

public func <-- (inout array: [Bool]?, value: AnyObject?) -> [Bool]? {
  if let boolArray = value as? [Bool] {
    array = boolArray
  } else {
    array = nil
  }
  return array
}

public func <-- (inout array: [Bool], value: AnyObject?) -> [Bool] {
  var newValue: [Bool]?
  newValue <-- value
  if let newValue = newValue { array = newValue }
  return array
}

public func <-- (inout array: [NSURL]?, value: AnyObject?) -> [NSURL]? {
  if let stringURLArray = value as? [String] {
    array = [NSURL]()
    for stringURL in stringURLArray {
      if let url = NSURL(string: stringURL) {
        array!.append(url)
      }
    }
  } else {
    array = nil
  }
  return array
}

public func <-- (inout array: [NSURL], value: AnyObject?) -> [NSURL] {
  var newValue: [NSURL]?
  newValue <-- value
  if let newValue = newValue { array = newValue }
  return array
}

public func <-- (inout array: [NSDate]?, valueAndFormat: (AnyObject?, AnyObject?)) -> [NSDate]? {
  var newValue: [NSDate]?
  if let dateStringArray = valueAndFormat.0 as? [String] {
    if let formatString = valueAndFormat.1 as? String {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = formatString
      newValue = [NSDate]()
      for dateString in dateStringArray {
        if let date = dateFormatter.dateFromString(dateString) {
          newValue!.append(date)
        }
      }
    }
  }
  array = newValue
  return array
}

public func <-- (inout array: [NSDate], valueAndFormat: (AnyObject?, AnyObject?)) -> [NSDate] {
  var newValue: [NSDate]?
  newValue <-- valueAndFormat
  if let newValue = newValue { array = newValue }
  return array
}

public func <-- (inout array: [NSDate]?, value: AnyObject?) -> [NSDate]? {
  if let timestamps = value as? [AnyObject] {
    array = [NSDate]()
    for timestamp in timestamps {
      var date: NSDate?
      date <-- timestamp
      if date != nil { array!.append(date!) }
    }
  } else {
    array = nil
  }
  return array
}

public func <-- (inout array: [NSDate], value: AnyObject?) -> [NSDate] {
  var newValue: [NSDate]?
  newValue <-- value
  if let newValue = newValue { array = newValue }
  return array
}

// MARK: Custom Object Deserialization

public protocol Deserializable {
  init(data: JSONDictionary)
}

public func <-- <T: Deserializable>(inout instance: T?, dataObject: AnyObject?) -> T? {
  if let data = dataObject as? JSONDictionary {
    instance = T(data: data)
  } else {
    instance = nil
  }
  return instance
}

public func <-- <T: Deserializable>(inout instance: T, dataObject: AnyObject?) -> T {
  var newInstance: T?
  newInstance <-- dataObject
  if let newInstance = newInstance { instance = newInstance }
  return instance
}

// MARK: Custom Object Array Deserialization

public func <-- <T: Deserializable>(inout array: [T]?, dataObject: AnyObject?) -> [T]? {
  if let dataArray = dataObject as? [JSONDictionary] {
    array = [T]()
    for data in dataArray {
      array!.append(T(data: data))
    }
  } else {
    array = nil
  }
  return array
}

public func <-- <T: Deserializable>(inout array: [T], dataObject: AnyObject?) -> [T] {
  var newArray: [T]?
  newArray <-- dataObject
  if let newArray = newArray { array = newArray }
  return array
}

// MARK: JSON String Deserialization

private func dataStringToObject(dataString: String) -> AnyObject? {
  var data: NSData = dataString.dataUsingEncoding(NSUTF8StringEncoding)!
  var error: NSError?
  return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
}

public func <-- <T: Deserializable>(inout instance: T?, dataString: String) -> T? {
  return instance <-- dataStringToObject(dataString)
}

public func <-- <T: Deserializable>(inout instance: T, dataString: String) -> T {
  return instance <-- dataStringToObject(dataString)
}

public func <-- <T: Deserializable>(inout array: [T]?, dataString: String) -> [T]? {
  return array <-- dataStringToObject(dataString)
}

public func <-- <T: Deserializable>(inout array: [T], dataString: String) -> [T] {
  return array <-- dataStringToObject(dataString)
}
