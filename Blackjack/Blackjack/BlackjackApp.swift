//
//  BlackjackApp.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/5/26.
//

import SwiftUI

@main
struct BlackjackApp: App {
    @State private var viewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            GameView(viewModel: viewModel)
        }
    }
}
