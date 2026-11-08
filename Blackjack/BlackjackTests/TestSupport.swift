//
//  TestSupport.swift
//  BlackjackTests
//
//  Created by Andrew Hoang on 11/8/26.
//

@testable import Blackjack

/// hand("AS", "KH") builds a hand from card codes. Test-only.
@MainActor
func hand(_ codes: String...) -> Hand {
    Hand(codes.map { Card(code: $0)! })
}

@MainActor
func cards(_ codes: String...) -> [Card] {
    codes.map { Card(code: $0)! }
}

@MainActor
func stackedGame(_ codes: String...) -> BlackjackGame {
    BlackjackGame(shuffler: StackedShuffler(topCards: codes.map { Card(code: $0)! }))
}
