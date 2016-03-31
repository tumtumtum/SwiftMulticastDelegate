# SwiftMuilticastDelegate

Multicast delegate support for Swift

A clean and easy to use implementation of multicast delegates for Swift.

Installation by adding "SwiftMulticastDelegate" to your Podfile and then importing SwiftMulticastDelegate in your source files. Alternatively you can simply copy `MulticastDelegate.swift` into your project.

### Declaring a delegate property

Declare a delegate property by declaring an optional var property of type MulticastDelegate<T> where T is your delegate protocol. The property should not be weak.

```swift
var delegate: MulticastDelegate<ButtonDelegate>?
```

### Invoking a delegate method

Invoke a delegate callback by using the overloaded `=>` operator and passing in a block that will retrieve a delegate protocol reference.

```swift
self.delegate => { $0.click() }
```

### Registering and unregistering for callbacks

You can register/unregister for callbacks using the overloaded `+=` and `-=` operators.

```swift
obj.delegate += { print "callback!" }
```

### Full Example

```swift

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
  let name: String
  
  init(name: String)
  {
      self.name = name
  }
  
  func clicked(sender: Button)
  {
    print("\(name): button clicked!")
  }
}

let button = Button()
let window1 = Window(name: "Window 1")
let window2 = Window(name: "Window 2")

button.delegate += window1
button.delegate += window2

button.onClick()

button.delegate -= window2

button.onClick()
```

Try the full example in a Swift [Sandbox](http://swiftlang.ng.bluemix.net/#/repl/4bc9593d704dcad4ae569dafdbfb3100c83671c0886419d88cfe2f4fac9ef834)
