//
//  Card.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/6/26.
//

import Foundation

enum Rank: Int, CaseIterable {
    case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
    var points: Int {
        switch self {
        case .jack, .queen, .king: 10
        default: rawValue
        }
    }
    
    var label: String {
        switch self {
        case .ace: "A"
        case .jack: "J"
        case .queen: "Q"
        case .king: "K"
        default: String(rawValue)
        }
    }
    
    var name: String {
        switch self {
            case .ace: "Ace"
            case .jack: "Jack"
            case .queen: "Queen"
            case .king: "King"
            default: String(rawValue)
        }
    }
}

enum Suit: CaseIterable {
    case spades, hearts, diamonds, clubs
    
    var symbol: String {
        switch self {
            case .spades: "♠"
            case .hearts: "♥"
            case .diamonds: "♦"
            case .clubs: "♣"
        }
    }
    var isRed: Bool { self == .hearts || self == .diamonds }
    var name: String { String(describing: self).capitalized }
    var letter: Character { String(describing: self).uppercased().first! }
}

struct Card: Hashable {
    let rank: Rank
    let suit: Suit
    
    var label: String { rank.label + suit.symbol }
    var spokenName: String { "\(rank.name) of \(suit.name)" }
    
    static let fullDeck: [Card] = {
        var deck: [Card] = []
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                deck.append(Card(rank: rank, suit: suit))
            }
        }
        return deck
    }()
}

extension Card {
    init?(code: String) {
        guard let suitLetter = code.last,
              let suit = Suit.allCases.first(where: {$0.letter == suitLetter}),
              let rank = Rank.allCases.first(where: {$0.label == String(code.dropLast()) })
        else {
            return nil
        }
        self.init(rank: rank, suit: suit)
    }
}

