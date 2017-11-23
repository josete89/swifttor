//
//  MainActor.swift
//  SwifttorExample
//
//  Created by Alcala, Jose Luis on 11/22/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Swifttor

enum MainActorMessages {
    case displayInfo(callback:(Model) -> (),data:Model)
    case refreshStuffWithData(callback:(String) -> (),data:String)
    case refreshStuff(callbac:() -> ())
}



struct MainActor: ActorTell {

    typealias MessageType = MainActorMessages
    
    func reiciveTell(message: MainActorMessages) {
        switch message {
        case .refreshStuffWithData(let callback,let data):
            callback(data)
        case .refreshStuff(let callback):
            callback()
        case .displayInfo(let callback,let data):
            callback(data)
        }
        
    }

}
