//
//  ParserActor.swift
//  SwifttorExample
//
//  Created by Alcala, Jose Luis on 11/23/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Swifttor

enum ParserkMessages{
    case parseToModel(data:Data)
}

struct ParserActor: ActorAsk {
    
    typealias ResultType = Result<Model,String>
    typealias MessageType = ParserkMessages
    
    func reiciveAsk(message: Result<Data,String>, completion: @escaping (Result<Model, String>) -> ()) {
        switch message {
        case .parseToModel(let data):
            if let result = try? JSONDecoder().decode(Model.self, from: data){
                completion(Result.success(result: result))
            }else{
                completion(Result.failure(error: "Cannot parse"))
            }
        }
    }
    
}
