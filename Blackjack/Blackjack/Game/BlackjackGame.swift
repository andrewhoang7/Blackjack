//
//  BlackjackGame.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import Foundation

struct BlackjackGame {
    enum Phase: Equatable {
        case betting
        case playerTurn
        case roundOver(Outcome)
    }

    static let defaultBankroll = 1000
    static let minimumBet = 10
    static let betStep = 10

    private(set) var phase: Phase = .betting
    private(set) var playerHand = Hand()
    private(set) var dealerHand = Hand()
    private(set) var balance: Int
    private(set) var currentBet = BlackjackGame.minimumBet
    private(set) var wagerInPlay = 0

    private let shuffler: any Shuffling
    private var deck: Deck

    init(shuffler: any Shuffling = RandomShuffler(), startingBalance: Int = BlackjackGame.defaultBankroll) {
        self.shuffler = shuffler
        self.deck = Deck(shuffler: shuffler)
        self.balance = startingBalance
    }

    // MARK: - What's allowed right now

    var isDealerHoleCardHidden: Bool { phase == .playerTurn }
    var canChangeBet: Bool { phase != .playerTurn }
    var canDeal: Bool { phase != .playerTurn && currentBet <= balance }
    var isOutOfChips: Bool { phase != .playerTurn && balance < Self.minimumBet }

    var canDoubleDown: Bool {
        phase == .playerTurn
            && playerHand.cards.count == 2
            && (9...11).contains(playerHand.value)
            && balance >= wagerInPlay
    }

    // MARK: - Betting

    mutating func changeBet(by amount: Int) {
        guard canChangeBet else { return }
        let newBet = currentBet + amount
        guard newBet >= Self.minimumBet, newBet <= balance else { return }
        currentBet = newBet
    }

    mutating func startOver() {
        guard phase != .playerTurn else { return }
        self = BlackjackGame(shuffler: shuffler)
    }

    // MARK: - Playing a round

    mutating func deal() {
        guard canDeal else { return }
        balance -= currentBet
        wagerInPlay = currentBet
        deck = Deck(shuffler: shuffler)
        playerHand = Hand()
        dealerHand = Hand()

        // Bicycle order: player, dealer (upcard), player, dealer (hole card).
        playerHand.add(deck.draw())
        dealerHand.add(deck.draw())
        playerHand.add(deck.draw())
        dealerHand.add(deck.draw())
        phase = .playerTurn

        if playerHand.isBlackjack || dealerHand.isBlackjack {
            finishRound()
        }
    }

    mutating func hit() {
        guard phase == .playerTurn else { return }
        playerHand.add(deck.draw())
        if playerHand.isBust {
            finishRound()
        } else if playerHand.value == 21 {
            playDealerAndFinish()
        }
    }

    mutating func stand() {
        guard phase == .playerTurn else { return }
        playDealerAndFinish()
    }

    mutating func doubleDown() {
        guard canDoubleDown else { return }
        balance -= wagerInPlay
        wagerInPlay *= 2
        playerHand.add(deck.draw())
        // From 9-11 one card can't bust; the check matters if the rule is loosened.
        if playerHand.isBust {
            finishRound()
        } else {
            playDealerAndFinish()
        }
    }

    // MARK: - Ending a round

    private mutating func playDealerAndFinish() {
        // The dealer has no choices: hit below 17, stand on any 17, soft 17 included.
        while dealerHand.value < 17 {
            dealerHand.add(deck.draw())
        }
        finishRound()
    }

    private mutating func finishRound() {
        let outcome = Outcome.settle(player: playerHand, dealer: dealerHand)
        balance += outcome.payout(for: wagerInPlay)
        wagerInPlay = 0
        phase = .roundOver(outcome)

        let affordable = balance / Self.betStep * Self.betStep
        currentBet = max(Self.minimumBet, min(currentBet, affordable))
    }
}
