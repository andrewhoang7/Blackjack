//
//  BlackjackApp.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/5/26.
//

import SwiftUI

@main
struct BlackjackApp: App {
    @State private var viewModel = GameViewModel(game: BlackjackGame(shuffler: BlackjackApp.makeShuffler()))

    var body: some Scene {
        WindowGroup {
            GameView(viewModel: viewModel)
        }
    }

    /// The one place that picks real or stacked cards.
    private static func makeShuffler() -> any Shuffling {
        if let stacked = StackedShuffler.fromLaunchEnvironment(ProcessInfo.processInfo.environment) {
            return stacked
        }
        return RandomShuffler()
    }
}
