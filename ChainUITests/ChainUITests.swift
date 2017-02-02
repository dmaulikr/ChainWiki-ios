//
//  ChainUITests.swift
//  ChainUITests
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import XCTest


class ChainUITests: XCTestCase {
    
//    func testScreenshots() {
//        let app = XCUIApplication()
//        let _ = app.tables
//        snapshot("Home")
//        
//        let tabBarsQuery = app.tabBars
//        tabBarsQuery.buttons["어빌리티"].tap()
//        app.buttons["인연"].tap()
//        
//        let tablesQuery = app.tables
//        tablesQuery.staticTexts["마나의 소양"].tap()
//        app.buttons["법사"].tap()
//        snapshot("Ability")
//        tabBarsQuery.buttons["주점"].tap()
//        snapshot("Tavern")
//        tabBarsQuery.buttons["아르카나"].tap()
//        tablesQuery.cells.containing(.staticText, identifier:"제파르").staticTexts["#마신"].tap()
//        
//        let arcanaDetailQuery = app.tables
//        let staticText = arcanaDetailQuery.children(matching: .cell).element(boundBy: 0).children(matching: .staticText).element
//        staticText.tap()
//        snapshot("ArcanaImage")
//        staticText.tap()
//        arcanaDetailQuery.staticTexts["운명역전의 천마 제파르 運命流転ノ天魔 ゼファル"].swipeUp()
//        snapshot("ArcanaDetail")
//    }
    
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
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
//        waitForElementToAppear(element: app.staticTexts["피나"])
        snapshot("Home")
    
//        let filterButton = app.navigationBars["Chain.Home"].buttons["filter"]
//        snapshot("Filter")
//        
//        app.tabBars.buttons["아르카나"].tap()
//        let tablesQuery = app.tables
//        tablesQuery.staticTexts["赤誠の雄"].tap()
//        tablesQuery.staticTexts["0"].tap()
//        snapshot("Detail")
//        
//        app.tabBars.buttons["어빌리티"].tap()
//        let collectionViewsQuery = app.collectionViews
//        collectionViewsQuery.cells.containing(.staticText, identifier:"인연").children(matching: .other).element.tap()
//        app.collectionViews.tables.staticTexts["마나의 소양"].tap()
//        snapshot("Ability")
//        
//        app.tabBars.buttons["주점"].tap()
//        app.collectionViews.tables.staticTexts["화염구령"].tap()
//        snapshot("Tavern")
    }
    
}
