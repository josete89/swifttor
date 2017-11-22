//
//  Promise.swift
//  Swifttor
//
//  Created by Alcala, Jose Luis on 11/17/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import Foundation

final public class Future<A> {
    private var callbacks: [(A) -> Void] = []
    private var cached: A?

    init(compute: (@escaping (A) -> Void) -> Void) {
        compute(self.send)
    }

    private func send(_ value: A) {
        assert(cached == nil)
        cached = value
        for callback in callbacks {
            callback(value)
        }
        callbacks = []
    }

    public func onResult(callback: @escaping (A) -> Void) {
        if let value = cached {
            callback(value)
        } else {
            callbacks.append(callback)
        }
    }

    public func map<B>(transform: @escaping (A) -> B) -> Future<B> {
        return self.flatMap { (response) -> Future<B> in
            Future<B>(compute: { (completion) in
                completion(transform(response))
            })
        }
    }

    public func flatMap<B>(transform: @escaping (A) -> Future<B>) -> Future<B> {
        return Future<B> { completion in
            self.onResult { result in
                transform(result).onResult(callback: completion)
            }
        }
    }
}

infix operator >>>:AdditionPrecedence

public func >>><A,B>(left:Future<A>, right: @escaping (A) -> Future<B>) -> Future<B> {
    return left.flatMap(transform: right)
}
