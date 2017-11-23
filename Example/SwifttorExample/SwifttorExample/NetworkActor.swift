//
//  NetworkActor.swift
//  SwifttorExample
//
//  Created by Alcala, Jose Luis on 11/23/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Swifttor
import Foundation

enum Result<A,B>{
    case success(A)
    case failure(B)
}

struct NetworkActor: ActorAsk {    
    
    typealias ResultType = Result<Data,String>
    typealias MessageType = URL
    
    func reiciveAsk(message: URL,completion:@escaping (Result<Data,String>)->()) {
        perfomNetWorkCall(url: message, completion: completion)
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
