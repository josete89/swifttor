//
//  MainActor.swift
//  SwifttorExample
//
//  Created by Alcala, Jose Luis on 11/22/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Swifttor



struct MainActor<T>: ActorTell {
    
    typealias MessageType = MainActorMessages
    var name:String {
        return "etes"
    }
    
    var queue: DispatchQueue {
        return DispatchQueue.main
    }
    
    enum MainActorMessages {
        case refreshStuffWithData(callback:(T) -> (),data:T)
        case refreshStuff(callbac:() -> ())
    }
    
    
    func reiciveTell(message: MainActor.MainActorMessages) {
        switch message {
        case .refreshStuff(let callback):
            callback()
        case .refreshStuffWithData(let callback, let data):
            callback(data)
        }
    }

}
