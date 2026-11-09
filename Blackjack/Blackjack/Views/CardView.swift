//
//  CardView.swift
//  Blackjack
//
//  Created by Andrew Hoang on 11/8/26.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var isFaceDown = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isFaceDown ? Color.blue : Color.white)
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
            if !isFaceDown {
                Text(card.label)
                    .font(.title2.bold())
                    .foregroundStyle(card.suit.isRed ? Color.red : Color.black)
            }
        }
        .frame(width: 56, height: 80)
        .shadow(radius: 2)
        .accessibilityElement()
        .accessibilityLabel(isFaceDown ? "Face-down card" : card.spokenName)
    }
}

#Preview {
    HStack {
        CardView(card: Card(rank: .ace, suit: .spades))
        CardView(card: Card(rank: .ten, suit: .hearts))
        CardView(card: Card(rank: .king, suit: .clubs), isFaceDown: true)
    }
}
