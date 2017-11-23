//
//  NetworkActor.swift
//  SwifttorExample
//
//  Created by Alcala, Jose Luis on 11/23/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Swifttor
import Foundation
enum NetWorkMessages{
    case fetchFromNetwork(url:URL)
}

struct NetworkActor: ActorAsk {
    
    typealias ResultType = Result<Data,String>
    
    typealias MessageType = NetWorkMessages
    
    func reiciveAsk(message: NetWorkMessages,completion:@escaping (Result<Data,String>)->()) {
        switch message {
        case .fetchFromNetwork(let url):
            perfomNetWorkCall(url: url, completion: completion)
        }
    }
    
    
    func perfomNetWorkCall(url:URL,completion:@escaping (Result<Data,String>)->()){
        let session = URLSession(configuration: .ephemeral)
        session.dataTask(with: url, completionHandler: { (data, response, err) in
            if let dat = data{
                completion(Result.success(result: dat))
            }else{
                completion(Result.failure(error: "error happend"))
            }
        }).resume()
    }
}
