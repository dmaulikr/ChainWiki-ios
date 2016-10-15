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
        setupSnapshot(app)
        snapshot("ArcanaHome")
//        app.tables.staticTexts["運命流転ノ天魔"].tap()
        app.navigationBars["Chain.Home"].buttons["filter"].tap()
        snapshot("ArcanaFilter")
        
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
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
