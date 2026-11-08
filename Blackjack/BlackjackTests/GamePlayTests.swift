//
//  GamePlayTests.swift
//  BlackjackTests
//
//  Created by Andrew Hoang on 11/8/26.
//

import XCTest
@testable import Blackjack

final class GamePlayTests: XCTestCase {
    @MainActor
    func testHitGivesPlayerTheNextCard() {
        var game = stackedGame("2S", "3S", "4S", "5S", "6S")
        game.deal()
        game.hit()
        XCTAssertEqual(game.playerHand.cards, cards("2S", "4S", "6S"))
        XCTAssertEqual(game.phase, .playerTurn)
    }

    @MainActor
    func testBustEndsTheRoundImmediately() {
        var game = stackedGame("10S", "9H", "6S", "8D", "KC")
        game.deal()
        game.hit()
        XCTAssertEqual(game.phase, .roundOver(.playerBust))
        XCTAssertEqual(game.dealerHand.cards.count, 2)
    }

    @MainActor
    func testHitAfterRoundEndsDoesNothing() {
        var game = stackedGame("10S", "9H", "6S", "8D", "KC", "2C")
        game.deal()
        game.hit()
        game.hit()
        XCTAssertEqual(game.playerHand.cards.count, 3)
    }

    @MainActor
    func testDealDuringPlayerTurnDoesNothing() {
        var game = stackedGame("2S", "3S", "4S", "5S", "6S")
        game.deal()
        game.hit()
        game.deal()
        XCTAssertEqual(game.playerHand.cards.count, 3)
    }

    @MainActor
    func testSoftHandSurvivesABigCard() {
        var game = stackedGame("AS", "9H", "5D", "8C", "KH")
        game.deal()
        game.hit()
        XCTAssertEqual(game.playerHand.value, 16)
        XCTAssertEqual(game.phase, .playerTurn)
    }

    @MainActor
    func testStandComparesHands() {
        var game = stackedGame("10S", "10H", "9S", "8D")
        game.deal()
        game.stand()
        XCTAssertEqual(game.phase, .roundOver(.playerWins))
    }

    @MainActor
    func testDealerHitsSixteen() {
        var game = stackedGame("10S", "10H", "9S", "6D", "5C")
        game.deal()
        game.stand()
        XCTAssertEqual(game.dealerHand.cards, cards("10H", "6D", "5C"))
        XCTAssertEqual(game.phase, .roundOver(.dealerWins))
    }

    @MainActor
    func testDealerStandsOnSoft17() {
        var game = stackedGame("10S", "AH", "8S", "6D", "5C")
        game.deal()
        game.stand()
        XCTAssertEqual(game.dealerHand.cards.count, 2)
        XCTAssertEqual(game.phase, .roundOver(.playerWins))
    }

    @MainActor
    func testDealerKeepsHittingAndCanBust() {
        var game = stackedGame("10S", "2H", "8S", "3D", "4C", "5H", "KD")
        game.deal()
        game.stand()
        XCTAssertEqual(game.dealerHand.value, 24)
        XCTAssertEqual(game.phase, .roundOver(.dealerBust))
    }

    @MainActor
    func testDealerSoftHandHardensAndKeepsDrawing() {
        var game = stackedGame("10S", "AH", "9S", "5D", "10C", "3H")
        game.deal()
        game.stand()
        XCTAssertEqual(game.dealerHand.value, 19)
        XCTAssertEqual(game.phase, .roundOver(.push))
    }

    @MainActor
    func testReachingTwentyOneStandsAutomatically() {
        var game = stackedGame("5S", "10H", "6S", "8D", "KC")
        game.deal()
        game.hit()
        XCTAssertEqual(game.playerHand.value, 21)
        XCTAssertEqual(game.phase, .roundOver(.playerWins))
    }
}
