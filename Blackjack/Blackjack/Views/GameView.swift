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
            .background(Color(.felt).ignoresSafeArea())
            .navigationTitle("Blackjack")
            .toolbar {
                Button("Rules") { showingRules = true }
                    .accessibilityIdentifier("rulesButton")
            }
            .sheet(isPresented: $showingRules) {
                RulesView()
            }
        }
        .preferredColorScheme(.dark)
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
                Button("Hit") { withAnimation { viewModel.hit() } }
                    .accessibilityIdentifier("hitButton")
                Button("Stand") { withAnimation { viewModel.stand() } }
                    .accessibilityIdentifier("standButton")
                Button("Double") { withAnimation { viewModel.doubleDown() } }
                    .disabled(!viewModel.canDoubleDown)
                    .accessibilityIdentifier("doubleButton")
            }
            .buttonStyle(.bordered)
        } else if viewModel.isOutOfChips {
            Button("Start over") { withAnimation { viewModel.startOver() } }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .accessibilityIdentifier("startOverButton")
        } else {
            Button("Deal") { withAnimation { viewModel.deal() } }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
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
