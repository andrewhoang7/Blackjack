//
//  Shuffling.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import Foundation

/// Puts a fresh deck in order. The app shuffles randomly; tests stack the deck.
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

extension StackedShuffler {
    /// Reads "AS,KH,9D" from STACKED_DECK. Only UI tests set it.
    static func fromLaunchEnvironment(_ environment: [String: String]) -> StackedShuffler? {
        guard let codes = environment["STACKED_DECK"] else { return nil }
        return StackedShuffler(topCards: codes.split(separator: ",").compactMap { Card(code: String($0)) })
    }
}
