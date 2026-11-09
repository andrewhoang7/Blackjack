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

    /// Waits for a button to appear, then taps it.
    @MainActor
    private func tap(_ identifier: String, in app: XCUIApplication,
                     file: StaticString = #filePath, line: UInt = #line) {
        let button = app.buttons[identifier]
        XCTAssertTrue(button.waitForExistence(timeout: 3), "\(identifier) never appeared", file: file, line: line)
        button.tap()
    }

    /// Waits until a label reads `expected`, so a check never catches text mid-update.
    @MainActor
    private func expect(_ identifier: String, in app: XCUIApplication, toRead expected: String,
                        file: StaticString = #filePath, line: UInt = #line) {
        let text = app.staticTexts[identifier].firstMatch
        let readsExpected = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "label == %@", expected), object: text)
        let result = XCTWaiter().wait(for: [readsExpected], timeout: 3)
        let actual = text.exists ? text.label : "nothing"
        XCTAssertTrue(result == .completed, "\(identifier) read \"\(actual)\", expected \"\(expected)\"",
                      file: file, line: line)
    }

    @MainActor
    func testPlayerBlackjackPaysThreeToTwo() {
        let app = launch(deck: "AS", "9H", "KD", "7C")
        tap("dealButton", in: app)
        expect("status", in: app, toRead: "Blackjack! You win 3:2.")
        expect("playerScore", in: app, toRead: "You: Blackjack")
        expect("balance", in: app, toRead: "Balance: 1015")
    }

    @MainActor
    func testHitToBustEndsTheRound() {
        let app = launch(deck: "10S", "9H", "6S", "8D", "KC")
        tap("dealButton", in: app)
        expect("dealerScore", in: app, toRead: "Dealer: ?")
        tap("hitButton", in: app)
        expect("status", in: app, toRead: "Bust! Dealer wins.")
        expect("dealerScore", in: app, toRead: "Dealer: 17")
        XCTAssertTrue(app.buttons["dealButton"].waitForExistence(timeout: 3))
    }

    @MainActor
    func testStandAndDealerBusts() {
        let app = launch(deck: "10S", "6H", "8S", "10D", "KC")
        tap("dealButton", in: app)
        tap("standButton", in: app)
        expect("status", in: app, toRead: "Dealer busts. You win!")
        expect("dealerScore", in: app, toRead: "Dealer: 26")
        expect("balance", in: app, toRead: "Balance: 1010")
    }

    @MainActor
    func testRaisedBetDoubledAndWon() {
        let app = launch(deck: "6S", "10H", "5S", "8D", "KC")
        tap("increaseBet", in: app)
        expect("bet", in: app, toRead: "Bet: 20")
        tap("dealButton", in: app)
        tap("doubleButton", in: app)
        expect("status", in: app, toRead: "You win!")
        expect("balance", in: app, toRead: "Balance: 1040")
    }

    @MainActor
    func testRulesSheetOpensAndCloses() {
        let app = launch(deck: "2S", "3S", "4S", "5S")
        tap("rulesButton", in: app)
        XCTAssertTrue(app.navigationBars["Rules"].waitForExistence(timeout: 3))
        tap("Done", in: app)
        XCTAssertTrue(app.buttons["dealButton"].waitForExistence(timeout: 3))
    }
}
