//
//  MulticastDelegateTests.swift
//  MulticastDelegateTests
//
//  Created by Thong Nguyen on 31/03/2016.
//  Copyright © 2016 King Street Apps Limited. All rights reserved.
//

import XCTest

@testable import SwiftMulticastDelegate

protocol ButtonDelegate: class
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

class MulticastDelegateTests: XCTestCase
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
    
    func test2()
    {
        let button1 = Button()
        var view1: View! = View()
        var view2: View! = View()
        var view1count: Int
        var view2count: Int
        
        button1.delegate += view1
        button1.delegate += view2
        
        button1.click()
        
        XCTAssert(button1.delegate !== nil)
        
        view1count = view1.count
        view1 = nil
        
        button1.click()
        
        XCTAssert(button1.delegate !== nil)
        
        view2count = view2.count
        view2 = nil
        
        button1.click()
        
        XCTAssert(button1.delegate === nil)
        
        XCTAssert(view1count == 1)
        XCTAssert(view2count == 2)
    }
}
