//
//  MulticastDelegateMacTests.swift
//  MulticastDelegateMacTests
//
//  Created by Thong Nguyen on 31/03/2016.
//  Copyright © 2016 King Street Apps Limited. All rights reserved.
//

import XCTest
@testable import MulticastDelegateMac

protocol ButtonDelegate
{
	func clicked()
}

class Button
{
	var delegate: MulticastDelegate<ButtonDelegate>?
	
	func click()
	{
		delegate => { $0.clicked() }
	}
}

class View: ButtonDelegate
{
	var count = 0
	
	func clicked()
	{
		count += 1
	}
}

class MulticastDelegateMacTests: XCTestCase
{
	override func setUp()
	{
		super.setUp()
	}
	
	override func tearDown()
	{
		super.tearDown()
	}
	
	func test()
	{
		let button1 = Button()
		let button2 = Button()
		let view1 = View()
		let view2 = View()
		
		button1.delegate += view1
		button1.delegate += view2
		button2.delegate += view1
		button2.delegate += view2
		
		let count1 = view1.count
		let count2 = view2.count
		
		button1.click()
		XCTAssert(view1.count == count1 + 1)
		button1.click()
		XCTAssert(view1.count == count1 + 2)
		button1.delegate -= view1
		button1.click()
		XCTAssert(view1.count == count1 + 2)
		XCTAssert(view2.count == count2 + 3)
		button1.delegate += view1
		button1.click()
		XCTAssert(view1.count == count1 + 3)
		XCTAssert(view2.count == count2 + 4)
		
		button2.click()
		XCTAssert(view1.count == count1 + 4)
		XCTAssert(view2.count == count2 + 5)
		
		button2.delegate -= view2
		button2.delegate -= view1
		button2.delegate -= view1
		button2.delegate -= view2
		button2.delegate += view2
		button2.delegate += view2
		button2.delegate += view1
		
		button2.click()
		
		XCTAssert(view1.count == count1 + 5)
		XCTAssert(view2.count == count2 + 7)
		
		button2.delegate -= view2
		button2.click()
		XCTAssert(view1.count == count1 + 6)
		XCTAssert(view2.count == count2 + 8)
		
		button2.delegate -= view2
		button2.click()
		XCTAssert(view1.count == count1 + 7)
		XCTAssert(view2.count == count2 + 8)
	}
}
