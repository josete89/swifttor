//
//  Promise.swift
//  Swifttor
//
//  Created by Alcala, Jose Luis on 11/17/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Foundation

final public class Future<A> {
    private var callbacks: [(Result<A>) -> Void] = []
    private var cached: Result<A>?

    public init(compute: (@escaping (Result<A>) -> Void) -> Void) {
        compute(self.send)
    }

    private func send(_ value: Result<A>) {
        assert(cached == nil)
        cached = value
        for callback in callbacks {
            callback(value)
        }
        callbacks = []
    }

    public func onResult(callback: @escaping (Result<A>) -> Void) {
        if let value = cached {
            callback(value)
        } else {
            callbacks.append(callback)
        }
    }

    public func map<B>(transform: @escaping (A) -> B) -> Future<B> {
        self.cached = self.cached?.map(transform) as! Result<_>
        return self<B>
    }

    public func flatMap<B>(transform: @escaping (A) -> Future<B>) -> Future<B> {
        return Future<B> { completion in
            self.onResult { result in
                switch result {
                case .success(let value):
                    transform(value).onResult(callback: completion)
                case .failure(let error):
                    completion(Result.failure(error: error))
                }
            }
        }
    }
}

public enum Result<A> {
    case success(result:A)
    case failure(error:String)
}
extension Result {
    func map<B>(_ transform: (A) -> B) -> Result<B> {
        switch self {
        case .success(let value): return .success(result: transform(value))
        case .failure(let error): return .failure(error: error)
        }
    }
}

infix operator >>>:AdditionPrecedence

public func >>><A,B>(left:Future<A>, right: @escaping (A) -> Future<B>) -> Future<B> {
    return left.flatMap(transform: right)
}

