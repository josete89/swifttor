//
//  ActorRef.swift
//  Swifttor
//
//  Created by Alcala, Jose Luis on 11/17/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Foundation

public struct ActorRef<T:Actor>:Equatable {
    let actor:T
    static public func == (lhs: ActorRef<T>, rhs: ActorRef<T>) -> Bool {
        return (lhs.actor == rhs.actor)
    }
}

extension ActorRef where T: ActorTell {
    public func tell(_ message:T.MessageType) {
        self.actor.put(message: message)
    }
}

extension ActorRef where T: ActorAsk {
    public func ask(_ message:T.MessageType) -> Future<T.ResultType> {
        return self.actor.putPromise(message: message)
    }
}
