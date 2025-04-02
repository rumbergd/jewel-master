# JewelMaster

A beautiful and engaging match-3 puzzle game built with SwiftUI for iOS. Match colorful jewels with unique shapes to score points and reach higher levels!

## Features

### Gameplay
- 8x8 game board with colorful, uniquely shaped jewels
- Match 3 or more identical jewels to score points
- Smooth animations for jewel swapping and matching
- Cascading matches for combo opportunities
- Progressive difficulty system

### Jewel Types
Each jewel has a unique shape and color combination:
- Red Diamond (♦️)
- Blue Pentagon (5-sided)
- Green Square (■)
- Yellow Triangle (▲)
- Purple Octagon (8-sided)
- Orange Hexagon (6-sided)
- Cyan Star (★)
- Pink Heart (♥️)

### Difficulty Progression
- Difficulty increases every 100 points
- New jewel types are introduced as you level up
- Starting with 5 jewel types at Level 1
- Maximum of 8 jewel types at higher levels

### Scoring System
- 10 points per matched jewel
- Chain reactions for higher scores
- High score tracking
- New high score celebrations

### Visual Effects
- 3D-styled jewels with gradients and shine
- Smooth swap animations
- Satisfying match animations
- Responsive layout for all iOS devices
- Support for both portrait and landscape orientations

## How to Play

1. **Basic Moves**
   - Tap a jewel to select it
   - Tap an adjacent jewel to swap positions
   - Only valid moves that create matches are allowed

2. **Making Matches**
   - Create horizontal or vertical lines of 3 or more identical jewels
   - Matched jewels will disappear
   - New jewels will fall from the top to fill empty spaces

3. **Strategy**
   - Look for potential chain reactions
   - Plan moves ahead as difficulty increases
   - Try to maximize points before running out of moves

4. **Game Over**
   - Game ends when no more valid moves are possible
   - Final score and level reached are displayed
   - Try to beat your high score!

## Technical Details

### Requirements
- iOS 14.0 or later
- Xcode 12.0 or later
- Swift 5.3 or later

### Architecture
- Built with SwiftUI
- MVVM architecture
- Reactive state management
- Hardware accelerated animations

### Installation
1. Clone the repository
2. Open `JewelMaster.xcodeproj` in Xcode
3. Build and run on your iOS device or simulator

## Credits

Created by Dmitry Rumberg (2025)
Built with SwiftUI and ❤️
