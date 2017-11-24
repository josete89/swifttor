
<img src="./images/logo.png" width="250px"/>

# Swifttor

[![Build Status](https://travis-ci.org/josete89/swifttor.svg?branch=master)](https://travis-ci.org/josete89/swifttor)
[![codecov](https://codecov.io/gh/josete89/swifttor/branch/master/graph/badge.svg)](https://codecov.io/gh/josete89/swifttor)

Swifttor is a library which allows you to use the actors paradimng from the popular akka library.

  - All the messages are being reicived on parallel.
  - Uses structs as actor so is easy to paralellize.
  - Works in all platforms.
  - Includes the ask and tell actions.
  - Can compose the ask calls


### Real example 

In the Example folder we have an example project which is using swifttor.

I've created 3 different actors

``` swift
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
```

``` swift
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
```

``` swift
struct MainActor: ActorTell {

    typealias MessageType = MainActorMessages
    
    func reiciveTell(message: MainActorMessages) {
        switch message {
        case .refreshStuffWithData(let callback,let data):
            callback(data)
        case .refreshStuff(let callback):
            callback()
        case .displayInfo(let callback,let data):
            callback(data)
        }
        
    }

}

```

And this are the enums used for messaging between them 

``` swift
enum MainActorMessages {
    case displayInfo(callback:(Model) -> (),data:Model)
    case refreshStuffWithData(callback:(String) -> (),data:String)
    case refreshStuff(callbac:() -> ())
}

```

``` swift
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

```
And now you are able to do this

``` swift
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
```


### Code examples

Create a new actor

``` swift
struct MainActor:ActorAsk,ActorTell {
    /* Optional if you don't specify creates a new one*/
    var queue: DispatchQueue {
        return DispatchQueue.main
    }

    typealias MessageType = String
    typealias ResulType = String
    
    func reiciveAsk(message: String,completion:@escaping(String)->Void) {
        completion(message)
    }
    
    func reiciveTell(message: String) {
        print(message)
    }
    
}
```

Inicialization 

``` swift
/*If we use this we are saving the actor in a cache*/
let actor1 = ActorSystem.actorOf(actorType: MainActor.self)

/*We are just craeting the actor without saving anywhere*/
let main = MainActor()
let actorRef = ActorSystem.actorOfInstance(main)
```

Compose calls
``` swift
let actor1 = ActorSystem.actorOf(actorType: MainActor.self)
let actor2 = ActorSystem.actorOf(actorType: MainActor.self)
let result = actor1 !! "Hello" >>> actor2.ask
result.onResult(callback:{
    print($0)
})
```

### How to add to your projects
Using one of this depency managers:
  - Carthage
  - Cocoapods
  - SwiftPM

### Todos
 - Deadletter
 - Mailbox

License
----

Apache 2.0





