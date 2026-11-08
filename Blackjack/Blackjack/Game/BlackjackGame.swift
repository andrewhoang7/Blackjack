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

    private(set) var phase: Phase = .betting
    private(set) var playerHand = Hand()
    private(set) var dealerHand = Hand()

    private let shuffler: any Shuffling
    private var deck: Deck

    var isDealerHoleCardHidden: Bool { phase == .playerTurn }

    init(shuffler: any Shuffling = RandomShuffler()) {
        self.shuffler = shuffler
        self.deck = Deck(shuffler: shuffler)
    }

    mutating func deal() {
        guard phase != .playerTurn else { return }
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

    private mutating func playDealerAndFinish() {
        // The dealer has no choices: hit below 17, stand on any 17, soft 17 included.
        while dealerHand.value < 17 {
            dealerHand.add(deck.draw())
        }
        finishRound()
    }

    private mutating func finishRound() {
        phase = .roundOver(Outcome.settle(player: playerHand, dealer: dealerHand))
    }
}
