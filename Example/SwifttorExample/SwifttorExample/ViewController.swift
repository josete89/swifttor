//
//  ViewController.swift
//  SwifttorExample
//
//  Created by Alcala, Jose Luis on 11/22/17.
//  Copyright © 2017 Alcala, Jose Luis. All rights reserved.
//

import UIKit
import Swifttor
class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let actorRef = ActorSystem.actorOf(actorType: MainActor.self)
        
        
        let networkActor = ActorSystem.actorOf(actorType: NetworkActor.self)
        let parserActor = ActorSystem.actorOf(actorType: ParserActor.self)
        networkActor.ask(.fetchFromNetwork(url: URL(string: "https://httpbin.org/ip")!)) >>> parserActor.ask
        
         res.onResult(callback: { r in
            switch r{
            case .success(result: let res):
                parserActor.ask(ParserkMessages.parseToModel(data: res)).onResult(callback: { res1 in
                    switch res1{
                    case .success( let res2):
                        actorRef.tell(MainActorMessages.refreshStuffWithData(callback: { input in
                            print(input)
                        }, data: res2.origin))
                    case .failure(let error):
                        actorRef.tell(MainActorMessages.refreshStuffWithData(callback: { input in
                            print(input)
                        }, data: error))
                    }
                    
                })
            case .failure(error: let err):
                print("hack")
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

