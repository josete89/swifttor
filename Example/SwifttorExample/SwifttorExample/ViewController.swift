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
        let actorChain =  networkActor.ask(URL(string: "https://httpbin.org/ip")!) >>> parserActor.ask
        
        actorChain.onResult { (result) in
            switch result {
            case .success(let model):
                actorRef.tell(MainActorMessages.displayInfo(callback: { print($0) }, data: model))
            case .failure(let err):
                actorRef.tell(MainActorMessages.refreshStuffWithData(callback: { print($0) }, data: err))
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

