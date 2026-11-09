//
//  BettingTests.swift
//  BlackjackTests
//
//  Created by Andrew Hoang on 11/8/26.
//

import XCTest
@testable import Blackjack

final class BettingTests: XCTestCase {
    @MainActor
    func testNewGameStartsWithBankrollAndMinimumBet() {
        let game = BlackjackGame()
        XCTAssertEqual(game.balance, 1000)
        XCTAssertEqual(game.currentBet, 10)
    }

    @MainActor
    func testDealTakesTheBet() {
        var game = stackedGame("2S", "3S", "4S", "5S")
        game.deal()
        XCTAssertEqual(game.balance, 990)
        XCTAssertEqual(game.wagerInPlay, 10)
    }

    @MainActor
    func testWinningPaysEvenMoney() {
        var game = stackedGame("10S", "10H", "9S", "8D")
        game.deal()
        game.stand()
        XCTAssertEqual(game.balance, 1010)
        XCTAssertEqual(game.wagerInPlay, 0)
    }

    @MainActor
    func testNaturalPaysThreeToTwo() {
        var game = stackedGame("AS", "9H", "KD", "7C")
        game.deal()
        XCTAssertEqual(game.balance, 1015)
    }

    @MainActor
    func testLosingKeepsTheBet() {
        var game = stackedGame("10S", "10H", "6S", "8D", "KC")
        game.deal()
        game.hit()
        XCTAssertEqual(game.balance, 990)
    }

    @MainActor
    func testPushReturnsTheBet() {
        var game = stackedGame("10S", "10H", "8S", "8D")
        game.deal()
        game.stand()
        XCTAssertEqual(game.balance, 1000)
    }

    @MainActor
    func testBetChangesInStepsWithinLimits() {
        var game = BlackjackGame(startingBalance: 30)
        game.changeBet(by: BlackjackGame.betStep)
        game.changeBet(by: BlackjackGame.betStep)
        XCTAssertEqual(game.currentBet, 30)
        game.changeBet(by: BlackjackGame.betStep)
        XCTAssertEqual(game.currentBet, 30, "40 is more than the balance")
        game.changeBet(by: -20)
        game.changeBet(by: -BlackjackGame.betStep)
        XCTAssertEqual(game.currentBet, 10, "0 is below the minimum")
    }

    @MainActor
    func testBetIsLockedDuringPlay() {
        var game = stackedGame("2S", "3S", "4S", "5S")
        game.deal()
        game.changeBet(by: BlackjackGame.betStep)
        XCTAssertEqual(game.currentBet, 10)
    }

    @MainActor
    func testCannotDealWithoutEnoughChips() {
        var game = BlackjackGame(startingBalance: 5)
        XCTAssertFalse(game.canDeal)
        game.deal()
        XCTAssertEqual(game.phase, .betting)
        XCTAssertEqual(game.balance, 5)
    }

    @MainActor
    func testBetShrinksToWhatYouCanAfford() {
        let shuffler = StackedShuffler(topCards: cards("10S", "10H", "6S", "8D", "KC"))
        var game = BlackjackGame(shuffler: shuffler, startingBalance: 50)
        game.changeBet(by: 30)      // bet 40
        game.deal()
        game.hit()                  // bust: 10 left
        XCTAssertEqual(game.balance, 10)
        XCTAssertEqual(game.currentBet, 10)
    }

    @MainActor
    func testStartOverRestoresTheBankroll() {
        var game = BlackjackGame(startingBalance: 5)
        XCTAssertTrue(game.isOutOfChips)
        game.startOver()
        XCTAssertEqual(game.balance, 1000)
        XCTAssertEqual(game.currentBet, 10)
        XCTAssertFalse(game.isOutOfChips)
    }

    @MainActor
    func testDoubleDownDoublesBetAndTakesOneCard() {
        var game = stackedGame("6S", "10H", "5S", "8D", "KC")
        game.deal()                 // player 11, dealer 18
        XCTAssertTrue(game.canDoubleDown)
        game.doubleDown()
        XCTAssertEqual(game.playerHand.cards.count, 3)
        XCTAssertEqual(game.phase, .roundOver(.playerWins))
        XCTAssertEqual(game.balance, 1020)
    }

    @MainActor
    func testDoubleDownOnlyOnNineTenOrEleven() {
        var game = stackedGame("10S", "10H", "8S", "8D")
        game.deal()                 // player 18
        XCTAssertFalse(game.canDoubleDown)
        game.doubleDown()
        XCTAssertEqual(game.playerHand.cards.count, 2)
        XCTAssertEqual(game.balance, 990)
    }

    @MainActor
    func testDoubleDownNeedsChipsToMatch() {
        let shuffler = StackedShuffler(topCards: cards("6S", "10H", "5S", "8D"))
        var game = BlackjackGame(shuffler: shuffler, startingBalance: 10)
        game.deal()
        XCTAssertFalse(game.canDoubleDown)
    }
}
