//
//  Deck.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import Foundation

struct Deck {
    private var cards: [Card]

    init(shuffler: any Shuffling) {
        cards = shuffler.shuffled(Card.fullDeck)
    }

    var count: Int { cards.count }

    mutating func draw() -> Card {
        precondition(!cards.isEmpty, "The deck ran out mid-round")
        return cards.removeFirst()
    }
}
