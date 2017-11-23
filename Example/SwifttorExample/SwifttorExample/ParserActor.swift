//
//  ParserActor.swift
//  SwifttorExample
//
//  Created by Alcala, Jose Luis on 11/23/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Swifttor


struct ParserActor: ActorAsk {
    
    typealias ResultType = Result<Model,String>
    typealias MessageType = Result<Data,String>
    
    func reiciveAsk(message: Result<Data,String>, completion: @escaping (Result<Model, String>) -> ()) {
        
        let result = message.fmap { (data) -> Result <Model,String>  in
            if let result = try? JSONDecoder().decode(Model.self, from: data){
                return Result.success(result)
            }
            return Result.failure("Cannot parse")
        }
        completion(result)
        
    }
    
}
