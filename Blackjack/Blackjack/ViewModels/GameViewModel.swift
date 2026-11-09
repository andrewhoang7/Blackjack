//
//  GameViewModel.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import Observation

/// Turns the game's state into what the screen shows, and passes taps to the game.
@MainActor
@Observable
final class GameViewModel {
    private(set) var game: BlackjackGame

    init(game: BlackjackGame = BlackjackGame()) {
        self.game = game
    }
    
    nonisolated deinit {}

    // MARK: - Cards and scores

    var playerCards: [Card] { game.playerHand.cards }
    var dealerCards: [Card] { game.dealerHand.cards }
    var isDealerHoleCardHidden: Bool { game.isDealerHoleCardHidden }

    var playerScoreText: String {
        game.playerHand.cards.isEmpty ? "You" : "You: \(Self.score(of: game.playerHand))"
    }

    var dealerScoreText: String {
        if game.dealerHand.cards.isEmpty { return "Dealer" }
        if game.isDealerHoleCardHidden { return "Dealer: ?" }
        return "Dealer: \(Self.score(of: game.dealerHand))"
    }

    // MARK: - Status and money

    var statusText: String {
        switch game.phase {
        case .betting: "Place your bet and deal."
        case .playerTurn: "Hit or stand?"
        case .roundOver(let outcome): Self.message(for: outcome)
        }
    }

    var balanceText: String { "Balance: \(game.balance)" }
    var betText: String { "Bet: \(game.currentBet)" }

    // MARK: - Which buttons work

    var isPlayerTurn: Bool { game.phase == .playerTurn }
    var canDeal: Bool { game.canDeal }
    var canDoubleDown: Bool { game.canDoubleDown }
    var isOutOfChips: Bool { game.isOutOfChips }
    var canIncreaseBet: Bool { game.canChangeBet && game.currentBet + BlackjackGame.betStep <= game.balance }
    var canDecreaseBet: Bool { game.canChangeBet && game.currentBet > BlackjackGame.minimumBet }

    // MARK: - Actions

    func deal() { game.deal() }
    func hit() { game.hit() }
    func stand() { game.stand() }
    func doubleDown() { game.doubleDown() }
    func increaseBet() { game.changeBet(by: BlackjackGame.betStep) }
    func decreaseBet() { game.changeBet(by: -BlackjackGame.betStep) }
    func startOver() { game.startOver() }

    // MARK: - Wording

    static func message(for outcome: Outcome) -> String {
        switch outcome {
        case .playerBlackjack: "Blackjack! You win 3:2."
        case .dealerBlackjack: "Dealer has blackjack."
        case .playerBust: "Bust! Dealer wins."
        case .dealerBust: "Dealer busts. You win!"
        case .playerWins: "You win!"
        case .dealerWins: "Dealer wins."
        case .push: "Push. Your bet is returned."
        }
    }

    private static func score(of hand: Hand) -> String {
        if hand.isBlackjack { return "Blackjack" }
        if hand.isSoft && hand.value < 21 { return "soft \(hand.value)" }
        return "\(hand.value)"
    }
}
