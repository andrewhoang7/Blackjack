//
//  DeckTests.swift
//  BlackjackTests
//
//  Created by Andrew Hoang on 11/8/26.
//

import Foundation
import XCTest
@testable import Blackjack

final class DeckTests: XCTestCase {
    @MainActor
    func testStackedShufflerPutsChosenCardsOnTop() {
        var deck = Deck(shuffler: StackedShuffler(topCards: cards("AS", "KH")))
        XCTAssertEqual(deck.draw(), Card(code: "AS"))
        XCTAssertEqual(deck.draw(), Card(code: "KH"))
    }

    @MainActor
    func testDrawingRemovesTheTopCard() {
        var deck = Deck(shuffler: RandomShuffler())
        XCTAssertEqual(deck.count, 52)
        _ = deck.draw()
        XCTAssertEqual(deck.count, 51)
    }

    @MainActor
    func testStackedDeckStillHas52Cards() {
        let deck = Deck(shuffler: StackedShuffler(topCards: cards("AS", "KH")))
        XCTAssertEqual(deck.count, 52)
    }

    @MainActor
    func testRandomShuffleKeepsEveryCard() {
        let shuffled = RandomShuffler().shuffled(Card.fullDeck)
        XCTAssertEqual(Set(shuffled), Set(Card.fullDeck))
    }
}
