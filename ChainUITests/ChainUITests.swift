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
//        setupSnapshot(app)
//
//        let tablesQuery = app.tables
        let cellText = app.staticTexts["제파르"]
        self.waitForElementToAppear(element: cellText, timeout: 30)
        snapshot("ArcanaHome")
//        app.tables.staticTexts["運命流転ノ天魔"].tap()
        app.navigationBars["Chain.Home"].buttons["filter"].tap()
        snapshot("ArcanaFilter")
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["어빌리티"].tap()
        app.tables.staticTexts["마나의 소양"].tap()
        app.buttons["법사"].tap()
        snapshot("ArcanaAbility")
        tabBarsQuery.buttons["주점"].tap()
        snapshot("TavernView")
        tabBarsQuery.buttons["아르카나"].tap()
        app.navigationBars["Chain.Home"].buttons["filter"].tap()
        
        let element = app.staticTexts["제파르"]
        self.waitForElementToAppear(element: element, timeout: 30)
        element.tap()
        let tablesQuery = app.tables
        let image = tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .staticText).element
        self.waitForElementToAppear(element: image)
        image.tap()
        snapshot("ArcanaImage")
        image.swipeUp()
        
        tablesQuery.cells.containing(.staticText, identifier:"40").children(matching: .staticText).matching(identifier: "40").element(boundBy: 0).swipeUp()
        snapshot("ArcanaDetail")
        tablesQuery.cells.containing(.staticText, identifier:"스킬 1").element.tap()
//        tablesQuery.staticTexts["범위 내에있는 모든 적에게 일정 시간마다 작은 타격을주고, 또한 다운한다."].tap()
        
        /*
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["어빌리티"].tap()
        app.buttons["전사"].tap()
        tabBarsQuery.buttons["주점"].tap()
        app.collectionViews.staticTexts["연대기대륙"].tap()
        app.navigationBars["연대기대륙"].buttons["주점"].tap()
        tabBarsQuery.buttons["즐겨찾기"].tap()
        tabBarsQuery.buttons["아르카나"].tap()

 */
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
