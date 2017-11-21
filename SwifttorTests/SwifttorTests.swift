//
//  SwifttorTests.swift
//  SwifttorTests
//
//  Created by Alcala, Jose Luis on 11/17/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import XCTest
#if os(iOS)
@testable import Swifttor
#elseif os(tvOS)
@testable import SwifttorTvOS
#elseif os(macOS)
@testable import SwifttorMacOS
#endif
    
struct MainActor:ActorAsk,ActorTell {
    
    var f:(() -> ())?
    
    var queue: DispatchQueue {
        return DispatchQueue.main
    }

    typealias MessageType = String
    typealias ResulType = String
    
    func reiciveAsk(message: String) -> String {

        return message
    }
    
    func reiciveTell(message: String) {
        if let function = f {
            function()
        }
        print(message)
    }
    
}

struct AnotherActor:ActorTell {
    var f:(() -> ())?
    typealias MessageType = String
    typealias ResulType = String
    func reiciveTell(message: String) {
        if let function = f {
            function()
        }
        print(message)
    }
}

class SwifttorTests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let actor1 = ActorSystem.actorOf(actorType: MainActor.self)
        let actor2 = ActorSystem.actorOf(actorType: MainActor.self)
        let exp = self.expectation(description: "testExample")
        let s = actor1 !! "Hello" >>> actor2.ask
        s.onResult(callback:{
            print($0)
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTell(){
        var main = MainActor()
        let exp = self.expectation(description: "testTell")
        main.f = {
            exp.fulfill()
        }
        let actorRef = ActorSystem.actorOfInstance(main)
        actorRef ! "tell"
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testCacheActors(){
        let actor1 = ActorSystem.actorOf(actorType: MainActor.self)
        let actor2 = ActorSystem.actorOf(actorType: MainActor.self)
        XCTAssert(dump(actor1) == dump(actor2))
        XCTAssert(actor1 == actor2)
    }
    
    
    func testActorOfInstance(){
        let main = MainActor()
        let actorRef = ActorSystem.actorOfInstance(main)
        XCTAssert(actorRef.actor == main)
    }
    
    func testQueue(){
        let another = AnotherActor()
        let actorRef = ActorSystem.actorOfInstance(another)
        let name = __dispatch_queue_get_label(actorRef.actor.queue)
        XCTAssert(String(cString:name, encoding: .utf8) != "com.josete89.swifttor.AnotherActor")
    }
    
    func testDefaultQueue(){
        let exp = self.expectation(description: "testDefaultQueue")
        var another = AnotherActor()
        another.f = {
            exp.fulfill()
        }
        let actorRef = ActorSystem.actorOfInstance(another)
        actorRef ! "Test"
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFuture(){
        let exp = self.expectation(description: "testFuture")
        Future { (completion) in
            completion(5)
            }.map { (res)  in
                return "\(res)-test"
            }.onResult { (res) in
                XCTAssert(res == "5-test")
                exp.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
