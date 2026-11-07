//
//  CardTests.swift
//  BlackjackTests
//
//  Created by Andrew Hoang on 11/6/26.
//

import XCTest
@testable import Blackjack

final class CardTests: XCTestCase {
    @MainActor
    func testNumberCardsAreWorthNumber() {
        XCTAssertTrue(Rank.seven.points == 7)
    }
    
    @MainActor
    func testFaceCardsAreWorth10() {
        for rank in [Rank.jack, Rank.queen, Rank.king] {
            XCTAssertEqual(rank.points, 10, "\(rank)")
        }
    }
    
    @MainActor
    func testAceIsWorthOneOnItsOwn() {
        XCTAssertEqual(Rank.ace.points, 1)
    }
    
    @MainActor
    func testFullDeckHas52DifferentCards() {
        XCTAssertEqual(Card.fullDeck.count, 52)
        XCTAssertEqual(Set(Card.fullDeck).count, 52)
    }
    
    @MainActor
    func testLabelShowsRankAndSuitSymbol() {
        XCTAssertEqual(Card(rank: .ten, suit: .hearts).label, "10♥")
        XCTAssertEqual(Card(rank: .queen, suit: .spades).label, "Q♠")
    }
    
    @MainActor
    func testSpokenNameReadsNaturally() {
        XCTAssertEqual(Card(rank: .queen, suit: .spades).spokenName, "Queen of Spades")
        XCTAssertEqual(Card(rank: .seven, suit: .hearts).spokenName, "7 of Hearts")
    }
    
    @MainActor
    func testParsesCardCodes() {
        XCTAssertEqual(Card(code: "AS"), Card(rank: .ace, suit: .spades))
        XCTAssertEqual(Card(code: "10H"), Card(rank: .ten, suit: .hearts))
        XCTAssertEqual(Card(code: "KD"), Card(rank: .king, suit: .diamonds))
    }
    
    @MainActor
    func testRejectsBadCodes() {
        XCTAssertNil(Card(code: "1S"))
        XCTAssertNil(Card(code: "AX"))
        XCTAssertNil(Card(code: ""))
    }
    

}
