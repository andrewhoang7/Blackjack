//
//  Outcome.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import Foundation

enum Outcome: Equatable {
    case playerBlackjack, dealerBlackjack, playerBust, dealerBust, playerWins, dealerWins, push

    /// The single place where the win rules live.
    static func settle(player: Hand, dealer: Hand) -> Outcome {
        if player.isBust { return .playerBust }

        switch (player.isBlackjack, dealer.isBlackjack) {
        case (true, true): return .push
        case (true, false): return .playerBlackjack
        case (false, true): return .dealerBlackjack
        case (false, false): break
        }

        if dealer.isBust { return .dealerBust }
        if player.value > dealer.value { return .playerWins }
        if player.value < dealer.value { return .dealerWins }
        return .push
    }

    /// Chips returned to the balance. The stake was already taken at the deal.
    func payout(for bet: Int) -> Int {
        switch self {
        case .playerBlackjack: bet + bet * 3 / 2
        case .playerWins, .dealerBust: bet * 2
        case .push: bet
        case .playerBust, .dealerBlackjack, .dealerWins: 0
        }
    }
}
