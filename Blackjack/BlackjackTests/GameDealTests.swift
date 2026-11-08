//
//  GameDealTests.swift
//  BlackjackTests
//
//  Created by Andrew Hoang on 11/8/26.
//

import Foundation
import XCTest
@testable import Blackjack

final class GameDealTests: XCTestCase {
    @MainActor
    func testNewGameWaitsForTheDeal() {
        let game = BlackjackGame()
        XCTAssertEqual(game.phase, .betting)
        XCTAssertTrue(game.playerHand.cards.isEmpty)
        XCTAssertTrue(game.dealerHand.cards.isEmpty)
    }

    @MainActor
    func testDealAlternatesPlayerThenDealer() {
        var game = stackedGame("2S", "3S", "4S", "5S")
        game.deal()
        XCTAssertEqual(game.playerHand.cards, cards("2S", "4S"))
        XCTAssertEqual(game.dealerHand.cards, cards("3S", "5S"))
        XCTAssertEqual(game.phase, .playerTurn)
    }

    @MainActor
    func testHoleCardIsHiddenOnlyDuringPlayerTurn() {
        var game = stackedGame("2S", "3S", "4S", "5S")
        XCTAssertFalse(game.isDealerHoleCardHidden)
        game.deal()
        XCTAssertTrue(game.isDealerHoleCardHidden)
    }

    @MainActor
    func testPlayerNaturalEndsRoundAtOnce() {
        var game = stackedGame("AS", "9H", "KD", "7C")
        game.deal()
        XCTAssertEqual(game.phase, .roundOver(.playerBlackjack))
    }

    @MainActor
    func testDealerNaturalEndsRoundAtOnce() {
        var game = stackedGame("9H", "AS", "7C", "KD")
        game.deal()
        XCTAssertEqual(game.phase, .roundOver(.dealerBlackjack))
    }

    @MainActor
    func testTwoNaturalsPushAtOnce() {
        var game = stackedGame("AS", "AH", "KD", "QC")
        game.deal()
        XCTAssertEqual(game.phase, .roundOver(.push))
    }

    @MainActor
    func testHoleCardShowsWhenRoundEnds() {
        var game = stackedGame("9H", "AS", "7C", "KD")
        game.deal()
        XCTAssertFalse(game.isDealerHoleCardHidden)
    }
}
