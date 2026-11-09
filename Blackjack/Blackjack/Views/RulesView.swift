//
//  RulesView.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import SwiftUI

struct RulesView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Text("Get closer to 21 than the dealer without going over.")
                Text("2–10 count their number. J, Q and K count 10. An ace counts 11, or 1 if 11 would bust you.")
                Text("An ace plus a ten-value card as your first two cards is blackjack. It pays 3:2.")
                Text("The dealer hits on 16 or less and stands on every 17, soft 17 included.")
                Text("Double down on 9, 10 or 11: your bet doubles and you get exactly one more card.")
                Text("Equal totals push, and your bet comes back.")
            }
            .navigationTitle("Rules")
            .toolbar { Button("Done") { dismiss() } }
        }
    }
}
