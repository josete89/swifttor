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

extension Result {
    func map<C>(_ transform: (A) -> C) -> Result<C,B> {
        switch self {
        case .success(let value): return .success(transform(value))
        case .failure(let error): return .failure(error)
        }
    }
    func fmap<C>(_ transform: (A) -> Result<C,B>) -> Result<C,B> {
        switch self {
        case .success(let value):
            return transform(value)
        case .failure(let error):
            return .failure(error)
        }
    }
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
                completion(Result.success(dat))
            }else{
                completion(Result.failure("error happend"))
            }
        }).resume()
    }
}
