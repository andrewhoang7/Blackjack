//
//  HandTests.swift
//  BlackjackTests
//
//  Created by Andrew Hoang on 11/8/26.
//

import XCTest
@testable import Blackjack

final class HandTests: XCTestCase {
    @MainActor
    func testEmptyHandIsWorthZero() {
        XCTAssertEqual(Hand().value, 0)
    }
    
    @MainActor
    func testAddsNumberCards() {
        XCTAssertEqual(hand("5S","9H").value, 14)
    }
    
    @MainActor
    func testAceCountsElevenWhenItFits() {
        XCTAssertEqual(hand("AS", "6H").value, 17)
    }
    
    @MainActor
    func testAceDropsToOneWhenElevenWouldBust() {
        let cards = hand("AS", "6H", "9D")
        XCTAssertEqual(cards.value, 16)
        XCTAssertFalse(cards.isSoft)
    }

    @MainActor
    func testTwoAcesAreTwelve() {
        XCTAssertEqual(hand("AS", "AH").value, 12)
    }

    @MainActor
    func testFourAcesAndASevenAreTwentyOne() {
        XCTAssertEqual(hand("AS", "AH", "AD", "AC", "7S").value, 21)
    }
    
    @MainActor
    func testOverTwentyOneIsBust() {
        XCTAssertTrue(hand("KS", "QH", "2D").isBust)
        XCTAssertFalse(hand("KS", "AH").isBust)
    }

    @MainActor
    func testBlackjackIsTwentyOneFromTwoCards() {
        XCTAssertTrue(hand("AS", "KH").isBlackjack)
        XCTAssertTrue(hand("10D", "AS").isBlackjack)
        XCTAssertFalse(hand("7S", "7H", "7D").isBlackjack)
    }
}
