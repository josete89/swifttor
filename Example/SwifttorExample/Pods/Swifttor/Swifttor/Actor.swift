//
//  Actor.swift
//  Swifttor
//
//  Created by Alcala, Jose Luis on 11/17/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Foundation

public protocol Actor:Equatable {
    var name:String { get }
    var queue:DispatchQueue {get}
    associatedtype MessageType
    init()
}

public protocol ActorTell: Actor {
    
    func reiciveTell(message:MessageType)

}

public protocol ActorAsk: Actor {

    associatedtype ResultType
    func reiciveAsk(message:MessageType,completion:@escaping(ResultType)->())
}

public extension Actor {

    var queue:DispatchQueue {
        return DispatchQueue(label: "com.josete89.swifttor.\(name)")
    }
    var name: String {
        let name = "\(self)"
        let finalName = String(name[..<name.index(name.startIndex, offsetBy: name.count - 2)])
        return finalName
    }
    static public func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.name == rhs.name)
    }
}

extension ActorTell {

    func put(message:MessageType) {
        self.queue.async(execute: {
            self.reiciveTell(message: message)
        })
    }

}

extension ActorAsk {

    func putPromise(message:MessageType) -> Future<ResultType> {
        return Future(compute: { (completion) in
            self.queue.async(execute: {
                 self.reiciveAsk(message: message,completion: completion)
            })
        })
    }

}
