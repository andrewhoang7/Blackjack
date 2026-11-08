//
//  OutcomeTests.swift
//  BlackjackTests
//
//  Created by Andrew Hoang on 11/8/26.
//

import XCTest
@testable import Blackjack

final class OutcomeTests: XCTestCase {
    @MainActor
    func testPlayerBustLosesEvenIfDealerWouldBust() {
        let outcome = Outcome.settle(player: hand("KS", "QH", "5D"), dealer: hand("KD", "6C", "9H"))
        XCTAssertEqual(outcome, .playerBust)
    }

    @MainActor
    func testPlayerNaturalBeatsDealerTwentyOne() {
        XCTAssertEqual(Outcome.settle(player: hand("AS", "KH"), dealer: hand("7D", "7C", "7H")), .playerBlackjack)
    }

    @MainActor
    func testDealerNaturalBeatsPlayerTwentyOne() {
        XCTAssertEqual(Outcome.settle(player: hand("7D", "7C", "7H"), dealer: hand("AS", "KH")), .dealerBlackjack)
    }

    @MainActor
    func testTwoNaturalsPush() {
        XCTAssertEqual(Outcome.settle(player: hand("AS", "KH"), dealer: hand("AD", "QC")), .push)
    }

    @MainActor
    func testDealerBustMeansPlayerWins() {
        XCTAssertEqual(Outcome.settle(player: hand("10S", "8H"), dealer: hand("10D", "6C", "9H")), .dealerBust)
    }

    @MainActor
    func testHigherTotalWins() {
        XCTAssertEqual(Outcome.settle(player: hand("10S", "9H"), dealer: hand("10D", "8C")), .playerWins)
        XCTAssertEqual(Outcome.settle(player: hand("10S", "7H"), dealer: hand("10D", "8C")), .dealerWins)
    }

    @MainActor
    func testEqualTotalsPush() {
        XCTAssertEqual(Outcome.settle(player: hand("10S", "8H"), dealer: hand("9D", "9C")), .push)
    }

    @MainActor
    func testPayoutReturnsStakePlusWinnings() {
        XCTAssertEqual(Outcome.playerBlackjack.payout(for: 10), 25)
        XCTAssertEqual(Outcome.playerWins.payout(for: 10), 20)
        XCTAssertEqual(Outcome.dealerBust.payout(for: 10), 20)
        XCTAssertEqual(Outcome.push.payout(for: 10), 10)
        XCTAssertEqual(Outcome.playerBust.payout(for: 10), 0)
        XCTAssertEqual(Outcome.dealerBlackjack.payout(for: 10), 0)
        XCTAssertEqual(Outcome.dealerWins.payout(for: 10), 0)
    }
}
