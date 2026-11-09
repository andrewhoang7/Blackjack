//
//  HandView.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import SwiftUI

struct HandView: View {
    let title: String
    let titleIdentifier: String
    let cards: [Card]
    var hiddenCardIndex: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .accessibilityIdentifier(titleIdentifier)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(cards.enumerated()), id: \.element) { index, card in
                        CardView(card: card, isFaceDown: index == hiddenCardIndex)
                    }
                }
            }
            .frame(height: 80)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
