//
//  Hand.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import Foundation

struct Hand: Equatable {
    private(set) var cards: [Card]

    init(_ cards: [Card] = []) {
        self.cards = cards
    }

    mutating func add(_ card: Card) {
        cards.append(card)
    }

    /// Every ace counted as 1.
    var hardValue: Int {
        cards.reduce(0) { total, card in total + card.rank.points }
    }

    /// True when one ace can count as 11 without busting.
    var isSoft: Bool {
        cards.contains { $0.rank == .ace } && hardValue + 10 <= 21
    }

    var value: Int {
        isSoft ? hardValue + 10 : hardValue
    }

    var isBust: Bool { value > 21 }
    
    var isBlackjack: Bool { cards.count == 2 && value == 21 }
}
