//
//  ActorSystem.swift
//  Swifttor
//
//  Created by Alcala, Jose Luis on 11/17/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Foundation

struct ActorSystem {
    
    fileprivate static var actors:[String:Any] = [:]
    
    static func actorOfInstance<T:Actor>(_ actor:T) -> ActorRef<T> {
        return ActorRef(actor: actor)
    }
    
    static func actorOf<T:Actor>(actorType:T.Type) -> ActorRef<T>  {
        let key = "\(actorType)"
        let act = actorType.init()
        let actorRef:ActorRef<T>
        
        if let instance = actors[key] as? ActorRef<T> {
            actorRef = instance
        }else {
            let instance = ActorRef(actor: act)
            actors[key] = instance
            actorRef = instance
        }
        return actorRef
    }
    
}


infix operator  !:AdditionPrecedence
infix operator  !!:AdditionPrecedence

public func !<T:ActorTell>(left:ActorRef<T>, right:T.MessageType) -> Void {
    left.tell(right)
}

public func !!<T:ActorAsk>(left:ActorRef<T>, right:T.MessageType) -> Future<T.ResultType> {
    return left.ask(right)
}
