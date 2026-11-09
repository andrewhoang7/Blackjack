# Blackjack

Andrew Hoang
November 8, 2026

## Brief Overview
- Blackjack users start with 1,000 "chips", set a bet in increments of 10, and deal. Users can hit, stand, or double down while the dealer's hole card stays hidden. When round finishes, the balance updates and the next hand can be dealt. A Rules sheet explains the game, and Start Over resets the bankroll

## Remarks on Implementation Decisions
- The game engine: `BlackjackGame` is a plain struct with no SwiftUI, so all of the rules can be tested without a screen
- One file for judging wins: `Outcome.settle` decides results, with the `payout(for:)` function handling the money so the rules are not spread across the views
- MVVM: `GameViewModel` is `@Observable` and turns the game's state into the text and button states the view shows. The view only reads from it and passes taps through
- Dependency injection for the deck: The deck is shuffled through a `Shuffling` protocol. The app uses `RandomShuffler`, and tests use `StackedShuffler` so the cards come out in a known order. When `STACKED_DECK` is set, the app launches with that stacked deck, so UI tests get the same hand every run

## Implementation Details
- Minimum deployment target is iOS 26.2, so the project needs Xcode 26 to build
- The dealer stands on every 17 (soft 17 included), and a double down is allowed on 9, 10, or 11 only
- Blackjack pays 3:2 using whole chips. Since bets move in steps of 10, the payout always comes out even
- `GameViewModel` uses a `nonisolated deinit`. Without it, the MainActor isolated deinit crashed the view model tests on teardown in the iOS 26.2 simulator
- Animations use SwiftUI's default timing through `withAnimation`, and accessibility identifiers were placed on the main elements so the UI tests can find them reliably

## Testing
- Unit tests: tests include card parsing, hand values and soft aces, outcomes and payouts, dealer play, betting limits, double down, and the view model's text and button states
- UI tests: tests include a natural paying 3:2, hitting to bust, standing into a dealer bust, raising the bet and doubling, and opening and closing the Rules sheet

## Known Limitations
- Splitting not supported
- The balance lives in memory, so it resets when the app relaunches
- The status and totals can update just before the last card finishes animating in

## If I Had More Time
- Splitting pairs, insurance, and surrender
- Persist the balance across launches
- More UI test coverage for running out of chips and starting over

