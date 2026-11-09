//
//  GameViewModelTests.swift
//  BlackjackTests
//
//  Created by Andrew Hoang on 11/8/26.
//

import XCTest
@testable import Blackjack

final class GameViewModelTests: XCTestCase {
    @MainActor
    func testStartsWaitingForADeal() {
        let viewModel = GameViewModel()
        XCTAssertEqual(viewModel.statusText, "Place your bet and deal.")
        XCTAssertEqual(viewModel.playerScoreText, "You")
        XCTAssertTrue(viewModel.canDeal)
        XCTAssertFalse(viewModel.isPlayerTurn)
    }

    @MainActor
    func testDealShowsPlayerScoreAndHidesDealerScore() {
        let viewModel = stackedViewModel("10S", "9H", "6S", "8D")
        viewModel.deal()
        XCTAssertEqual(viewModel.playerScoreText, "You: 16")
        XCTAssertEqual(viewModel.dealerScoreText, "Dealer: ?")
        XCTAssertTrue(viewModel.isDealerHoleCardHidden)
        XCTAssertEqual(viewModel.playerCards, cards("10S", "6S"))
    }

    @MainActor
    func testMessageForEachOutcome() {
        let expected: [(Outcome, String)] = [
            (.playerBlackjack, "Blackjack! You win 3:2."),
            (.dealerBlackjack, "Dealer has blackjack."),
            (.playerBust, "Bust! Dealer wins."),
            (.dealerBust, "Dealer busts. You win!"),
            (.playerWins, "You win!"),
            (.dealerWins, "Dealer wins."),
            (.push, "Push. Your bet is returned."),
        ]
        for (outcome, message) in expected {
            XCTAssertEqual(GameViewModel.message(for: outcome), message)
        }
    }

    @MainActor
    func testStatusFollowsThePhase() {
        let viewModel = stackedViewModel("10S", "9H", "6S", "8D", "KC")
        viewModel.deal()
        XCTAssertEqual(viewModel.statusText, "Hit or stand?")
        viewModel.hit()
        XCTAssertEqual(viewModel.statusText, "Bust! Dealer wins.")
    }

    @MainActor
    func testScoresReadNaturally() {
        let viewModel = stackedViewModel("AS", "10H", "6S", "8D")
        viewModel.deal()
        XCTAssertEqual(viewModel.playerScoreText, "You: soft 17")
        viewModel.stand()
        XCTAssertEqual(viewModel.dealerScoreText, "Dealer: 18")
        XCTAssertEqual(viewModel.statusText, "Dealer wins.")
    }

    @MainActor
    func testNaturalReadsAsBlackjack() {
        let viewModel = stackedViewModel("AS", "9H", "KD", "7C")
        viewModel.deal()
        XCTAssertEqual(viewModel.playerScoreText, "You: Blackjack")
        XCTAssertEqual(viewModel.dealerScoreText, "Dealer: 16")
    }

    @MainActor
    func testButtonsFollowThePhase() {
        let viewModel = stackedViewModel("6S", "10H", "5S", "8D", "KC")
        XCTAssertFalse(viewModel.canDecreaseBet)
        XCTAssertTrue(viewModel.canIncreaseBet)
        viewModel.increaseBet()
        XCTAssertEqual(viewModel.betText, "Bet: 20")
        viewModel.decreaseBet()
        viewModel.deal()
        XCTAssertTrue(viewModel.canDoubleDown)
        XCTAssertFalse(viewModel.canIncreaseBet)
        viewModel.doubleDown()
        XCTAssertFalse(viewModel.isPlayerTurn)
        XCTAssertEqual(viewModel.balanceText, "Balance: 1020")
    }
}
