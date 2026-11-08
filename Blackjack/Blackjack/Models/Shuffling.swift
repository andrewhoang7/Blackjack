//
//  Shuffling.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import Foundation

/// Puts a fresh deck in order
protocol Shuffling {
    func shuffled(_ cards: [Card]) -> [Card]
}

struct RandomShuffler: Shuffling {
    func shuffled(_ cards: [Card]) -> [Card] {
        cards.shuffled()
    }
}

/// Deals `topCards` first, in order, then the rest of the deck unshuffled.
struct StackedShuffler: Shuffling {
    let topCards: [Card]

    func shuffled(_ cards: [Card]) -> [Card] {
        topCards + cards.filter { !topCards.contains($0) }
    }
}
