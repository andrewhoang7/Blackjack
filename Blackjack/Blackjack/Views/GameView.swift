//
//  GameView.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import SwiftUI

struct GameView: View {
    let viewModel: GameViewModel
    @State private var showingRules = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                HandView(
                    title: viewModel.dealerScoreText,
                    titleIdentifier: "dealerScore",
                    cards: viewModel.dealerCards,
                    hiddenCardIndex: viewModel.isDealerHoleCardHidden ? 1 : nil
                )
                Text(viewModel.statusText)
                    .font(.title3)
                    .accessibilityIdentifier("status")
                HandView(
                    title: viewModel.playerScoreText,
                    titleIdentifier: "playerScore",
                    cards: viewModel.playerCards
                )
                Spacer()
                bankroll
                controls
            }
            .padding()
            .navigationTitle("Blackjack")
            .toolbar {
                Button("Rules") { showingRules = true }
                    .accessibilityIdentifier("rulesButton")
            }
            .sheet(isPresented: $showingRules) {
                RulesView()
            }
        }
    }

    private var bankroll: some View {
        HStack(spacing: 16) {
            Text(viewModel.balanceText)
                .accessibilityIdentifier("balance")
            Spacer()
            Button { viewModel.decreaseBet() } label: { Image(systemName: "minus.circle") }
                .disabled(!viewModel.canDecreaseBet)
                .accessibilityLabel("Decrease bet")
                .accessibilityIdentifier("decreaseBet")
            Text(viewModel.betText)
                .monospacedDigit()
                .accessibilityIdentifier("bet")
            Button { viewModel.increaseBet() } label: { Image(systemName: "plus.circle") }
                .disabled(!viewModel.canIncreaseBet)
                .accessibilityLabel("Increase bet")
                .accessibilityIdentifier("increaseBet")
        }
    }

    @ViewBuilder
    private var controls: some View {
        if viewModel.isPlayerTurn {
            HStack(spacing: 12) {
                Button("Hit") { viewModel.hit() }
                    .accessibilityIdentifier("hitButton")
                Button("Stand") { viewModel.stand() }
                    .accessibilityIdentifier("standButton")
                Button("Double") { viewModel.doubleDown() }
                    .disabled(!viewModel.canDoubleDown)
                    .accessibilityIdentifier("doubleButton")
            }
            .buttonStyle(.bordered)
        } else if viewModel.isOutOfChips {
            Button("Start over") { viewModel.startOver() }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("startOverButton")
        } else {
            Button("Deal") { viewModel.deal() }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canDeal)
                .accessibilityIdentifier("dealButton")
        }
    }
}

#Preview("New game") {
    GameView(viewModel: GameViewModel())
}

#Preview("Out of chips") {
    GameView(viewModel: GameViewModel(game: BlackjackGame(startingBalance: 5)))
}
