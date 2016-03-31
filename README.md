# SwiftMuilticastDelegate

Multicast delegate support for Swift

A clean and easy to use implementation of multicast delegates for Swift.

Installation by adding "pod SwiftMulticastDelegate" to your podfile or simply by copying `MulticastDelegate.swift` into your project.

### Declaring a delegate property

Declare a delegate property by declaring an optional var property of type MulticastDelegate<T> where T is your delegate protocol. The property should not be weak.

```swift
var delegate: MulticastDelegate<ButtonDelegate>?
```

### Invoking a delegate method

Invoke a delegate callback by using the overloaded `=>` operator on the delegate. The first argument of the block is the delegate. The block will be invoked for each delegate that has registered.

```swift
self.delegate => { $0.click() }
```

### Registering and unregistering for callbacks

You can register or unregister for callbacks using the overloaded `+=` and `-=` operators.

```swift
obj.delegate += { print "callback!" }
```

### Full Example

```swift
import SwiftMulticastDelegate


protocol ButtonDelegate
{
  func clicked(sender: Button)
}

class Button
{
  var delegate: MulticastDelegate<ButtonDelegate>?
  
  func onClick()
  {
    self.delegate => { $0.clicked(self) }
  }
}

class Window: ButtonDelegate
{
  let button = Button()
  
  init()
  {
    button.delegate += self  
  }
  
  deinit
  {
    // Unnecessary but here for completeness
    
    button.delegate -= self
  }
  
  func clicked(sender: Button)
  {
    print("button clicked!")
  }
}

let window = Window()

window.button.onClick()
```

Try the full example in a Swift [Sandbox](http://swiftlang.ng.bluemix.net/#/repl/b2a4b280085c693e023ccd2ad45bedae3b0abf24736bddf84aa12479a2b39e82)
