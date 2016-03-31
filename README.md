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

public func += <T> (inout left: MulticastDelegate<T>?, right: T)
{
	if left != nil
	{
		left = MulticastDelegate<T>.addDelegate(left!, delegate: right)
	}
	else
	{
		left = MulticastDelegate<T>(delegate: right as! AnyObject)
	}
}

public func -= <T> (inout left: MulticastDelegate<T>?, right: T)
{
	if left != nil
	{
		left = MulticastDelegate<T>.removeDelegate(left!, delegate: right)
	}
}

infix operator => {}

public func => <T> (inout left: MulticastDelegate<T>?, invocation: (T) -> ())
{
	if left != nil
	{
		let old = left
		let cleaned = MulticastDelegate<T>.invoke(left!, invocation: invocation)
		
		if old === left
		{
			left = cleaned
		}
	}
}

private struct WeakRef: Equatable
{
	weak var value: AnyObject?
	
	init(value: AnyObject)
	{
		self.value = value
	}
}

private func ==(lhs: WeakRef, rhs: WeakRef) -> Bool
{
	return lhs.value === rhs.value
}

public class MulticastDelegate<T>
{
	private var delegates: [WeakRef]
	
	private init(delegate: AnyObject)
	{
		self.delegates = [WeakRef(value: delegate)]
	}
	
	private init(delegates: Array<WeakRef>)
	{
		self.delegates = delegates
	}
	
	private init(delegates: Array<WeakRef>, delegate: AnyObject)
	{
		var copy = delegates
		
		copy.append(WeakRef(value: delegate))
		
		self.delegates = copy
	}
	
	static func addDelegate(multicastDelegate: MulticastDelegate<T>, delegate: T) -> MulticastDelegate<T>?
	{
		if let delegate = delegate as? AnyObject
		{
			return MulticastDelegate<T>(delegates: multicastDelegate.delegates, delegate: delegate)
		}
		
		return multicastDelegate
	}
	
	static func removeDelegate(multicastDelegate: MulticastDelegate<T>, delegate: T) -> MulticastDelegate<T>?
	{
		for (index, ref) in multicastDelegate.delegates.enumerate()
		{
			if ref.value === delegate as? AnyObject
			{
				if multicastDelegate.delegates.count == 1
				{
					return nil
				}
				
				var newDelegates = Array<WeakRef>(multicastDelegate.delegates[0..<index])
				
				if multicastDelegate.delegates.count - index - 1 > 0
				{
					newDelegates.appendContentsOf(multicastDelegate.delegates[index + 1..<multicastDelegate.delegates.count])
				}
				
				return MulticastDelegate<T>(delegates: newDelegates)
			}
		}
		
		return multicastDelegate
	}
	
	static func invoke(multicastDelegate: MulticastDelegate<T>, invocation: (T) -> ()) -> MulticastDelegate<T>?
	{
		var newDelegates: Array<WeakRef>? = nil
		
		for (index, ref) in multicastDelegate.delegates.enumerate()
		{
			if let delegate = ref.value
			{
				invocation(delegate as! T)
				
				if var newDelegates = newDelegates
				{
					newDelegates.append(ref)
				}
			}
			else
			{
				if newDelegates == nil && index > 0
				{
					newDelegates = Array(multicastDelegate.delegates[0..<index])
				}
			}
		}
		
		if let newDelegates = newDelegates
		{
			return MulticastDelegate<T>(delegates: newDelegates)
		}
		
		return multicastDelegate
	}
}

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
