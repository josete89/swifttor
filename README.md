# Swifttor

[![Build Status](https://travis-ci.org/josete89/swifttor.svg?branch=master)](https://travis-ci.org/josete89/swifttor)
[![codecov](https://codecov.io/gh/josete89/swifttor/branch/master/graph/badge.svg)](https://codecov.io/gh/josete89/swifttor)

Swifttor is a library which allows you to use the actors paradimng from the popular akka librar.

  - All the messages are being reicived on pararllel
  - Uses structs as actor so is easy to paralellize
  - Works in all platforms
  - Includes the ask and tell actions
  - Can compose the ask calls

### Code examples

Create a new actor

```
struct MainActor:ActorAsk,ActorTell {
    /* Optional if you don't specify creates a new one*/
    var queue: DispatchQueue {
        return DispatchQueue.main
    }

    typealias MessageType = String
    typealias ResulType = String
    
    func reiciveAsk(message: String) -> String {
        return message
    }
    
    func reiciveTell(message: String) {
        print(message)
    }
    
}
```

Inicialization 

```
/*If we use this we are saving the actor in a cache*/
let actor1 = ActorSystem.actorOf(actorType: MainActor.self)

/*We are just craeting the actor without saving anywhere*/
let main = MainActor()
let actorRef = ActorSystem.actorOfInstance(main)
```

Compose calls
```
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





