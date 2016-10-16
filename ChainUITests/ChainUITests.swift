//
//  ChainUITests.swift
//  ChainUITests
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import XCTest

class ChainUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScreenshots() {
        let app = XCUIApplication()
        let _ = app.tables
        snapshot("Home")
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["어빌리티"].tap()
        app.buttons["인연"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["마나의 소양"].tap()
        app.buttons["법사"].tap()
        snapshot("Ability")
        tabBarsQuery.buttons["주점"].tap()
        snapshot("Tavern")
        tabBarsQuery.buttons["아르카나"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"제파르").staticTexts["#마신"].tap()
        
        let arcanaDetailQuery = XCUIApplication().tables
        let staticText = arcanaDetailQuery.children(matching: .cell).element(boundBy: 0).children(matching: .staticText).element
        staticText.tap()
        snapshot("ArcanaImage")
        staticText.tap()
        arcanaDetailQuery.staticTexts["운명역전의 천마 제파르 運命流転ノ天魔 ゼファル"].swipeUp()
        snapshot("ArcanaDetail")
        
        
    }
    
    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 10,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        expectation(for: existsPredicate,
                    evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
