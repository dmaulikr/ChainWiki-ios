//
//  ChainUITests.swift
//  ChainUITests
//
//  Created by Jitae Kim on 4/1/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import XCTest

class ChainUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        continueAfterFailure = false

    }

    func testTakeScreenshots() {
        
        let app = XCUIApplication()
        
        snapshot("SearchView")
        
        let filterButton = app.navigationBars["아르카나"].buttons["filter"]
        filterButton.tap()
        
        app.tabBars.buttons["어빌리티"].tap()
        app.collectionViews.element(boundBy: 0).tap()
        app.tables.element(boundBy: 1).staticTexts["마나의 소양"].tap()
        
        snapshot("AbilityView")
        
        app.tabBars.buttons["주점"].tap()
        app.collectionViews.tables.staticTexts["화염구령"].tap()
        
        snapshot("TavernView")
        
    }
    
    
}
