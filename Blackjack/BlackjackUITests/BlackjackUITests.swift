//
//  BlackjackUITests.swift
//  BlackjackUITests
//
//  Created by Andrew Hoang on 11/6/26.
//

import XCTest

final class BlackjackUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Launches with a known deck. Deal order: player, dealer, player, dealer, then hits.
    @MainActor
    private func launch(deck codes: String...) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment["STACKED_DECK"] = codes.joined(separator: ",")
        app.launch()
        return app
    }

    @MainActor
    func testPlayerBlackjackPaysThreeToTwo() {
        let app = launch(deck: "AS", "9H", "KD", "7C")
        app.buttons["dealButton"].tap()
        XCTAssertEqual(app.staticTexts["status"].label, "Blackjack! You win 3:2.")
        XCTAssertEqual(app.staticTexts["playerScore"].label, "You: Blackjack")
        XCTAssertEqual(app.staticTexts["balance"].label, "Balance: 1015")
    }

    @MainActor
    func testHitToBustEndsTheRound() {
        let app = launch(deck: "10S", "9H", "6S", "8D", "KC")
        app.buttons["dealButton"].tap()
        XCTAssertEqual(app.staticTexts["dealerScore"].label, "Dealer: ?")
        app.buttons["hitButton"].tap()
        XCTAssertEqual(app.staticTexts["status"].label, "Bust! Dealer wins.")
        XCTAssertEqual(app.staticTexts["dealerScore"].label, "Dealer: 17")
        XCTAssertTrue(app.buttons["dealButton"].exists)
    }

    @MainActor
    func testStandAndDealerBusts() {
        let app = launch(deck: "10S", "6H", "8S", "10D", "KC")
        app.buttons["dealButton"].tap()
        app.buttons["standButton"].tap()
        XCTAssertEqual(app.staticTexts["status"].label, "Dealer busts. You win!")
        XCTAssertEqual(app.staticTexts["dealerScore"].label, "Dealer: 26")
        XCTAssertEqual(app.staticTexts["balance"].label, "Balance: 1010")
    }

    @MainActor
    func testRaisedBetDoubledAndWon() {
        let app = launch(deck: "6S", "10H", "5S", "8D", "KC")
        app.buttons["increaseBet"].tap()
        XCTAssertEqual(app.staticTexts["bet"].label, "Bet: 20")
        app.buttons["dealButton"].tap()
        app.buttons["doubleButton"].tap()
        XCTAssertEqual(app.staticTexts["status"].label, "You win!")
        XCTAssertEqual(app.staticTexts["balance"].label, "Balance: 1040")
    }

    @MainActor
    func testRulesSheetOpensAndCloses() {
        let app = launch(deck: "2S", "3S", "4S", "5S")
        app.buttons["rulesButton"].tap()
        XCTAssertTrue(app.navigationBars["Rules"].waitForExistence(timeout: 2))
        app.buttons["Done"].tap()
        XCTAssertTrue(app.buttons["dealButton"].waitForExistence(timeout: 2))
    }
    
}
