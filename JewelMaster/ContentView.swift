//
//  ContentView.swift
//  JewelMaster
//
//  Created by Dmitry Rumberg on 4/1/25.
//

import SwiftUI

// MARK: - Models
enum JewelType: CaseIterable {
    case red, blue, green, yellow, purple, orange, cyan, pink
    
    var color: Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .yellow: return .yellow
        case .purple: return .purple
        case .orange: return .orange
        case .cyan: return .cyan
        case .pink: return .pink
        }
    }
    
    var shape: JewelShape {
        switch self {
        case .red: return .diamond
        case .blue: return .pentagon
        case .green: return .square
        case .yellow: return .triangle
        case .purple: return .octagon
        case .orange: return .hexagon
        case .cyan: return .star
        case .pink: return .heart
        }
    }
}

enum JewelShape {
    case diamond, pentagon, square, triangle, octagon, hexagon, star, heart
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        switch self {
        case .diamond:
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            
        case .pentagon:
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(width, height) / 2
            var points: [CGPoint] = []
            
            for i in 0..<5 {
                let angle = Double(i) * 2 * .pi / 5 - .pi / 2
                points.append(CGPoint(
                    x: center.x + CGFloat(cos(angle)) * radius,
                    y: center.y + CGFloat(sin(angle)) * radius
                ))
            }
            
            path.move(to: points[0])
            for point in points[1...] {
                path.addLine(to: point)
            }
            
        case .hexagon:
            let sideLength = width * 0.25
            let points = [
                CGPoint(x: rect.midX, y: rect.minY),
                CGPoint(x: rect.maxX - sideLength, y: rect.minY + height * 0.25),
                CGPoint(x: rect.maxX - sideLength, y: rect.maxY - height * 0.25),
                CGPoint(x: rect.midX, y: rect.maxY),
                CGPoint(x: rect.minX + sideLength, y: rect.maxY - height * 0.25),
                CGPoint(x: rect.minX + sideLength, y: rect.minY + height * 0.25)
            ]
            path.move(to: points[0])
            for point in points[1...] {
                path.addLine(to: point)
            }
            
        case .star:
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let outerRadius = min(width, height) / 2
            let innerRadius = outerRadius * 0.4
            var points: [CGPoint] = []
            
            for i in 0..<10 {
                let angle = Double(i) * .pi / 5
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                points.append(CGPoint(
                    x: center.x + CGFloat(cos(angle)) * radius,
                    y: center.y + CGFloat(sin(angle)) * radius
                ))
            }
            
            path.move(to: points[0])
            for point in points[1...] {
                path.addLine(to: point)
            }
            
        case .heart:
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let size = min(width, height)
            
            path.move(to: CGPoint(x: center.x, y: center.y + size * 0.3))
            path.addCurve(
                to: CGPoint(x: center.x - size/2, y: center.y - size * 0.2),
                control1: CGPoint(x: center.x - size/2, y: center.y + size * 0.3),
                control2: CGPoint(x: center.x - size/2, y: center.y)
            )
            path.addArc(
                center: CGPoint(x: center.x - size * 0.3, y: center.y - size * 0.2),
                radius: size * 0.2,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: center.x + size * 0.3, y: center.y - size * 0.2),
                radius: size * 0.2,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
            path.addCurve(
                to: CGPoint(x: center.x, y: center.y + size * 0.3),
                control1: CGPoint(x: center.x + size/2, y: center.y),
                control2: CGPoint(x: center.x + size/2, y: center.y + size * 0.3)
            )
            
        case .square:
            let cornerRadius = width * 0.1
            path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                       radius: cornerRadius,
                       startAngle: Angle(degrees: -90),
                       endAngle: Angle(degrees: 0),
                       clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                       radius: cornerRadius,
                       startAngle: Angle(degrees: 0),
                       endAngle: Angle(degrees: 90),
                       clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                       radius: cornerRadius,
                       startAngle: Angle(degrees: 90),
                       endAngle: Angle(degrees: 180),
                       clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
            path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                       radius: cornerRadius,
                       startAngle: Angle(degrees: 180),
                       endAngle: Angle(degrees: 270),
                       clockwise: false)
            
        case .triangle:
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            
        case .octagon:
            let side = width * 0.3
            let points = [
                CGPoint(x: rect.minX + side, y: rect.minY),
                CGPoint(x: rect.maxX - side, y: rect.minY),
                CGPoint(x: rect.maxX, y: rect.minY + side),
                CGPoint(x: rect.maxX, y: rect.maxY - side),
                CGPoint(x: rect.maxX - side, y: rect.maxY),
                CGPoint(x: rect.minX + side, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.maxY - side),
                CGPoint(x: rect.minX, y: rect.minY + side)
            ]
            path.move(to: points[0])
            for point in points[1...] {
                path.addLine(to: point)
            }
        }
        
        path.closeSubpath()
        return path
    }
}

struct Jewel: Identifiable, Equatable {
    let id = UUID()
    var type: JewelType
    var position: CGPoint
    var isSelected = false
    var isMatched = false
    var offset: CGSize = .zero
    var isGameOver = false
    
    static func == (lhs: Jewel, rhs: Jewel) -> Bool {
        lhs.id == rhs.id
    }
}

class GameBoard: ObservableObject {
    @Published var jewels: [[Jewel]] = []
    @Published var score = 0 {
        didSet {
            if score > highScore {
                highScore = score
                UserDefaults.standard.set(highScore, forKey: "HighScore")
            }
            
            // Update difficulty level every 100 points
            currentLevel = score / 100 + 1
            availableJewelTypes = Array(JewelType.allCases.prefix(min(5 + currentLevel, JewelType.allCases.count)))
        }
    }
    @Published var highScore: Int
    @Published var selectedJewel: Jewel?
    @Published private(set) var currentLevel = 1
    @Published var noMovesAvailable = false
    let boardSize = 8
    
    private var availableJewelTypes: [JewelType]
    private let cellSize: CGFloat = 40
    private let cellSpacing: CGFloat = 8
    
    init() {
        highScore = UserDefaults.standard.integer(forKey: "HighScore")
        availableJewelTypes = Array(JewelType.allCases.prefix(5))
        resetBoard(animated: false)
    }
    
    func resetBoard(animated: Bool = true) {
        score = 0
        currentLevel = 1
        availableJewelTypes = Array(JewelType.allCases.prefix(5))
        selectedJewel = nil
        
        var newBoard: [[Jewel]] = []
        for row in 0..<boardSize {
            var newRow: [Jewel] = []
            for col in 0..<boardSize {
                newRow.append(Jewel(
                    type: availableJewelTypes.randomElement()!,
                    position: CGPoint(x: col, y: row)
                ))
            }
            newBoard.append(newRow)
        }
        
        // Ensure no matches exist initially
        while hasMatches(in: newBoard) {
            for row in 0..<boardSize {
                for col in 0..<boardSize {
                    if newBoard[row][col].isMatched {
                        newBoard[row][col] = Jewel(
                            type: availableJewelTypes.randomElement()!,
                            position: CGPoint(x: col, y: row)
                        )
                    }
                }
            }
            checkMatches(in: &newBoard)
        }
        
        if animated {
            withAnimation {
                jewels = newBoard
            }
        } else {
            jewels = newBoard
        }
    }
    
    private func hasMatches(in board: [[Jewel]]) -> Bool {
        // Check horizontal matches
        for row in 0..<boardSize {
            for col in 0..<(boardSize-2) {
                if board[row][col].type == board[row][col+1].type &&
                    board[row][col].type == board[row][col+2].type {
                    return true
                }
            }
        }
        
        // Check vertical matches
        for row in 0..<(boardSize-2) {
            for col in 0..<boardSize {
                if board[row][col].type == board[row+1][col].type &&
                    board[row][col].type == board[row+2][col].type {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func checkMatches(in board: inout [[Jewel]]) {
        // Check horizontal matches
        for row in 0..<boardSize {
            for col in 0..<(boardSize-2) {
                if board[row][col].type == board[row][col+1].type &&
                    board[row][col].type == board[row][col+2].type {
                    board[row][col].isMatched = true
                    board[row][col+1].isMatched = true
                    board[row][col+2].isMatched = true
                }
            }
        }
        
        // Check vertical matches
        for row in 0..<(boardSize-2) {
            for col in 0..<boardSize {
                if board[row][col].type == board[row+1][col].type &&
                    board[row][col].type == board[row+2][col].type {
                    board[row][col].isMatched = true
                    board[row+1][col].isMatched = true
                    board[row+2][col].isMatched = true
                }
            }
        }
    }
    
    private func checkAndRemoveMatches() {
        var matchFound = false
        var markedForRemoval = Set<CGPoint>()
        
        // Check horizontal matches
        for row in 0..<boardSize {
            for col in 0..<(boardSize-2) {
                if jewels[row][col].type == jewels[row][col+1].type &&
                    jewels[row][col].type == jewels[row][col+2].type {
                    markedForRemoval.insert(CGPoint(x: col, y: row))
                    markedForRemoval.insert(CGPoint(x: col+1, y: row))
                    markedForRemoval.insert(CGPoint(x: col+2, y: row))
                    matchFound = true
                }
            }
        }
        
        // Check vertical matches
        for row in 0..<(boardSize-2) {
            for col in 0..<boardSize {
                if jewels[row][col].type == jewels[row+1][col].type &&
                    jewels[row][col].type == jewels[row+2][col].type {
                    markedForRemoval.insert(CGPoint(x: col, y: row))
                    markedForRemoval.insert(CGPoint(x: col, y: row+1))
                    markedForRemoval.insert(CGPoint(x: col, y: row+2))
                    matchFound = true
                }
            }
        }
        
        // Remove matched jewels and update score
        if matchFound {
            score += markedForRemoval.count * 10
            
            // Mark jewels for removal
            withAnimation(.easeInOut(duration: 0.2)) {
                for point in markedForRemoval {
                    jewels[Int(point.y)][Int(point.x)].isMatched = true
                }
            }
            
            // Fill empty spaces after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.fillEmptySpaces()
            }
        }
    }
    
    private func fillEmptySpaces() {
        var droppedJewels = [(jewel: Jewel, fromRow: Int, toRow: Int)]()
        
        // Process column by column
        for col in 0..<boardSize {
            var emptySpaces = 0
            
            // Count empty spaces from bottom to top
            for row in (0..<boardSize).reversed() {
                if jewels[row][col].isMatched {
                    emptySpaces += 1
                } else if emptySpaces > 0 {
                    // Record jewels that need to drop
                    let droppedJewel = (
                        jewel: jewels[row][col],
                        fromRow: row,
                        toRow: row + emptySpaces
                    )
                    droppedJewels.append(droppedJewel)
                }
            }
            
            // Calculate new jewels needed at the top
            if emptySpaces > 0 {
                for i in 0..<emptySpaces {
                    let newJewel = Jewel(
                        type: availableJewelTypes.randomElement()!,
                        position: CGPoint(x: Double(col), y: Double(-i - 1))
                    )
                    let droppedJewel = (
                        jewel: newJewel,
                        fromRow: -i - 1,
                        toRow: emptySpaces - i - 1
                    )
                    droppedJewels.append(droppedJewel)
                }
            }
        }
        
        // Animate all drops simultaneously
        withAnimation(.easeIn(duration: 0.3)) {
            // Set initial positions and offsets for dropping jewels
            for dropped in droppedJewels {
                let dropDistance = CGFloat(dropped.toRow - dropped.fromRow) * (cellSize + cellSpacing)
                let finalPosition = CGPoint(x: dropped.jewel.position.x, y: CGFloat(dropped.toRow))
                
                if dropped.fromRow < 0 {
                    // New jewels from above the board
                    var newJewel = dropped.jewel
                    newJewel.position = finalPosition
                    newJewel.offset = CGSize(width: 0, height: -dropDistance)
                    jewels[dropped.toRow][Int(dropped.jewel.position.x)] = newJewel
                } else {
                    // Existing jewels that need to drop
                    var droppedJewel = dropped.jewel
                    droppedJewel.position = finalPosition
                    droppedJewel.offset = CGSize(width: 0, height: -dropDistance)
                    jewels[dropped.toRow][Int(dropped.jewel.position.x)] = droppedJewel
                }
            }
        }
        
        // After setting up initial positions, animate to final positions
        withAnimation(.easeOut(duration: 0.3)) {
            for col in 0..<boardSize {
                for row in 0..<boardSize {
                    jewels[row][col].offset = .zero
                    jewels[row][col].isMatched = false
                }
            }
        }
        
        // Check for new matches after dropping
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.checkAndRemoveMatches()
        }
        
        // After all animations complete, check for possible moves
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if !self.checkForPossibleMoves() {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.noMovesAvailable = true
                    // Turn all jewels gray
                    for row in 0..<self.boardSize {
                        for col in 0..<self.boardSize {
                            self.jewels[row][col].isGameOver = true
                        }
                    }
                }
            }
        }
    }
    
    private func checkForPossibleMoves() -> Bool {
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let jewel = jewels[row][col]
                
                // Check horizontal moves
                if col < boardSize - 1 {
                    let nextJewel = jewels[row][col + 1]
                    if canSwap(jewel, nextJewel) {
                        return true
                    }
                }
                
                // Check vertical moves
                if row < boardSize - 1 {
                    let nextJewel = jewels[row + 1][col]
                    if canSwap(jewel, nextJewel) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    private func canSwap(_ jewel1: Jewel, _ jewel2: Jewel) -> Bool {
        // Create a temporary board to simulate the swap
        var tempBoard = jewels
        
        // Swap the jewels
        let temp = tempBoard[Int(jewel1.position.y)][Int(jewel1.position.x)]
        tempBoard[Int(jewel1.position.y)][Int(jewel1.position.x)] = tempBoard[Int(jewel2.position.y)][Int(jewel2.position.x)]
        tempBoard[Int(jewel2.position.y)][Int(jewel2.position.x)] = temp
        
        // Check for matches
        if hasMatches(in: tempBoard) {
            return true
        }
        
        return false
    }
    
    func selectJewel(at position: CGPoint) {
        let row = Int(position.y)
        let col = Int(position.x)
        
        guard row >= 0 && row < boardSize && col >= 0 && col < boardSize else { return }
        
        if let selectedJewel = selectedJewel {
            let row1 = Int(selectedJewel.position.y)
            let col1 = Int(selectedJewel.position.x)
            
            // Check if the selected jewel is adjacent
            let isAdjacent = abs(row1 - row) + abs(col1 - col) == 1
            
            if isAdjacent {
                // Calculate the offset for the animation
                let dx = CGFloat(col - col1) * (cellSize + cellSpacing)
                let dy = CGFloat(row - row1) * (cellSize + cellSpacing)
                
                // First, check if the swap would create a match
                var tempBoard = jewels
                tempBoard[row1][col1].position = CGPoint(x: col, y: row)
                tempBoard[row][col].position = CGPoint(x: col1, y: row1)
                
                let temp = tempBoard[row1][col1]
                tempBoard[row1][col1] = tempBoard[row][col]
                tempBoard[row][col] = temp
                
                if hasMatches(in: tempBoard) {
                    // Valid move - perform the swap with animation
                    withAnimation(.easeInOut(duration: 0.2)) {
                        jewels[row1][col1].offset = CGSize(width: dx, height: dy)
                        jewels[row][col].offset = CGSize(width: -dx, height: -dy)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.jewels[row1][col1].offset = .zero
                        self.jewels[row][col].offset = .zero
                        self.jewels[row1][col1].position = CGPoint(x: col, y: row)
                        self.jewels[row][col].position = CGPoint(x: col1, y: row1)
                        
                        let temp = self.jewels[row1][col1]
                        self.jewels[row1][col1] = self.jewels[row][col]
                        self.jewels[row][col] = temp
                        
                        self.checkAndRemoveMatches()
                    }
                } else {
                    // Invalid move - animate swap and return
                    withAnimation(.easeInOut(duration: 0.2)) {
                        jewels[row1][col1].offset = CGSize(width: dx, height: dy)
                        jewels[row][col].offset = CGSize(width: -dx, height: -dy)
                    }
                    
                    // Wait and then animate back
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.jewels[row1][col1].offset = .zero
                            self.jewels[row][col].offset = .zero
                        }
                    }
                }
                
                // Clear selection
                withAnimation {
                    jewels[row1][col1].isSelected = false
                    self.selectedJewel = Optional.none
                }
            } else {
                // Select the new jewel instead
                withAnimation {
                    jewels[row1][col1].isSelected = false
                    jewels[row][col].isSelected = true
                    self.selectedJewel = jewels[row][col]
                }
            }
        } else {
            // First selection
            withAnimation {
                jewels[row][col].isSelected = true
                self.selectedJewel = jewels[row][col]
            }
        }
    }
}

// MARK: - Views
struct ScoreView: View {
    let score: Int
    let title: String
    let isHighScore: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("\(score)")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(isHighScore ? .blue : .primary)
        }
        .frame(minWidth: 80)
    }
}

struct GradientButtonStyle: ButtonStyle {
    let backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(backgroundColor)
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct JewelView: View {
    let jewel: Jewel
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Base shape with gradient
            jewel.type.shape.path(in: CGRect(x: 0, y: 0, width: size, height: size))
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: (jewel.isGameOver ? Color.gray : jewel.type.color).opacity(0.7), location: 0),
                            .init(color: jewel.isGameOver ? Color.gray : jewel.type.color, location: 0.5),
                            .init(color: (jewel.isGameOver ? Color.gray : jewel.type.color).opacity(0.8), location: 1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Inner shadow for depth
            jewel.type.shape.path(in: CGRect(x: 0, y: 0, width: size, height: size))
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .white.opacity(0.5), location: 0),
                            .init(color: .clear, location: 0.3),
                            .init(color: .black.opacity(0.3), location: 0.8),
                            .init(color: .black.opacity(0.5), location: 1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Shine effect
            jewel.type.shape.path(in: CGRect(x: 0, y: 0, width: size, height: size))
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: .white.opacity(0.3), location: 0),
                            .init(color: .clear, location: 0.5)
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size
                    )
                )
            
            // Edge highlight
            jewel.type.shape.path(in: CGRect(x: 0, y: 0, width: size, height: size))
                .stroke(
                    jewel.isGameOver ? 
                        Color.gray.opacity(0.5) :
                        (jewel.isSelected ? .white : jewel.type.color.opacity(0.8)),
                    lineWidth: jewel.isSelected ? 3 : 1
                )
        }
        .frame(width: size, height: size)
        .scaleEffect(jewel.isSelected ? 1.1 : 1.0)
        .scaleEffect(jewel.isMatched ? 0 : 1.0)
        .opacity(jewel.isMatched ? 0 : 1)
        .shadow(
            color: (jewel.isGameOver ? Color.gray : jewel.type.color).opacity(0.5),
            radius: jewel.isSelected ? 10 : 5,
            x: 0,
            y: jewel.isSelected ? 5 : 2
        )
        .offset(jewel.offset)
        .animation(.easeInOut(duration: 0.2), value: jewel.isMatched)
        .animation(.easeInOut(duration: 0.3), value: jewel.offset)
        .animation(.easeInOut(duration: 0.2), value: jewel.isSelected)
        .animation(.easeInOut(duration: 0.3), value: jewel.isGameOver)
    }
}

struct CongratsView: View {
    let score: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Trophy emoji with glow
            Text("🏆")
                .font(.system(size: 80))
                .shadow(color: .yellow.opacity(0.5), radius: 20)
            
            // Congratulations text
            VStack(spacing: 8) {
                Text("New Record!")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text("\(score) Points")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            // Confetti description
            Text("Keep up the great work! 🎉")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // Close button
            Button("Continue Playing") {
                withAnimation {
                    isPresented = false
                }
            }
            .buttonStyle(GradientButtonStyle(backgroundColor: .blue))
            .padding(.top, 10)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
        )
        .padding(40)
        .transition(.scale.combined(with: .opacity))
    }
}

struct LevelBadgeView: View {
    let level: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .imageScale(.small)
            
            Text("Level \(level)")
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
    }
}

struct GameOverView: View {
    @ObservedObject var gameBoard: GameBoard
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            // Game Over Header
            VStack(spacing: 8) {
                Image(systemName: "flag.checkered.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                
                Text("Game Over!")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
            }
            
            // No Moves Message
            Text("NO MORE POSSIBLE MOVES")
                .font(.headline)
                .foregroundColor(.red)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red, lineWidth: 2)
                )
            
            // Score Section
            VStack(spacing: 12) {
                Text("Final Score")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("\(gameBoard.score)")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                if gameBoard.score == gameBoard.highScore && gameBoard.score > 0 {
                    Text("New High Score! 🎉")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            
            // Level Reached
            Text("Level \(gameBoard.currentLevel) Reached")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.purple, .blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .foregroundColor(.white)
            
            // Close Button
            Button("Close") {
                withAnimation {
                    isPresented = false
                    gameBoard.noMovesAvailable = false
                }
            }
            .buttonStyle(GradientButtonStyle(backgroundColor: .blue))
            .padding(.top, 8)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
        )
        .padding(40)
        .transition(.scale.combined(with: .opacity))
    }
}

struct ContentView: View {
    @StateObject private var gameBoard = GameBoard()
    @State private var showingHighScore = false
    @State private var showingCongrats = false
    @State private var showingGameOver = false
    @State private var hasShownCongratsThisGame = false
    @State private var lastHighScore = UserDefaults.standard.integer(forKey: "HighScore")
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                if isLandscape {
                    // Landscape layout
                    HStack(spacing: 0) {
                        // Left side controls
                        controlsView
                            .frame(width: geometry.size.width * 0.25)
                            .padding()
                        
                        // Centered game board
                        ZStack {
                            gameBoardView(in: geometry, isLandscape: true)
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    // Portrait layout
                    VStack(spacing: 0) {
                        // Top controls
                        controlsView
                            .padding(.horizontal)
                            .padding(.top, 30)
                        
                        // Centered game board with consistent spacing
                        gameBoardView(in: geometry, isLandscape: false)
                            .padding(.top, 30)
                    }
                }
                
                // Overlays
                if showingCongrats {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    
                    CongratsView(score: gameBoard.score, isPresented: $showingCongrats)
                }
                
                if gameBoard.noMovesAvailable {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .transition(.opacity)
                    
                    GameOverView(gameBoard: gameBoard, isPresented: $showingGameOver)
                }
            }
            .onChange(of: gameBoard.noMovesAvailable) { isGameOver in
                if isGameOver {
                    showingGameOver = true
                }
            }
            .onChange(of: gameBoard.score) { newScore in
                if newScore > lastHighScore && lastHighScore > 0 && !hasShownCongratsThisGame {
                    withAnimation {
                        showingCongrats = true
                        hasShownCongratsThisGame = true
                    }
                }
                lastHighScore = gameBoard.highScore
            }
            .alert("Reset High Score?", isPresented: $showingHighScore) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    gameBoard.highScore = 0
                    lastHighScore = 0
                    hasShownCongratsThisGame = false
                    UserDefaults.standard.set(0, forKey: "HighScore")
                }
            } message: {
                Text("Are you sure you want to reset your high score of \(gameBoard.highScore)?")
            }
        }
    }
    
    private func gameBoardView(in geometry: GeometryProxy, isLandscape: Bool) -> some View {
        let boardSize = isLandscape ?
            min(geometry.size.height * 0.95, geometry.size.width * 0.6) :
            min(geometry.size.width * 0.95, geometry.size.height * 0.6)
        let cellSize = boardSize / CGFloat(gameBoard.boardSize)
        let spacing = cellSize * 0.12
        
        return LazyVGrid(columns: Array(repeating: GridItem(.fixed(cellSize - spacing), spacing: spacing),
                                    count: gameBoard.boardSize),
                      spacing: spacing) {
            ForEach(0..<gameBoard.boardSize, id: \.self) { row in
                ForEach(0..<gameBoard.boardSize, id: \.self) { col in
                    JewelView(jewel: gameBoard.jewels[row][col],
                             size: cellSize - spacing)
                        .onTapGesture {
                            withAnimation {
                                gameBoard.selectJewel(at: CGPoint(x: col, y: row))
                            }
                        }
                }
            }
        }
        .padding(spacing)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .frame(width: boardSize, height: boardSize)
    }
    
    private var controlsView: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 16) {
                Text("JewelMaster")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                LevelBadgeView(level: gameBoard.currentLevel)
                
                // Score container
                HStack(spacing: 24) {
                    ScoreView(
                        score: gameBoard.score,
                        title: "SCORE",
                        isHighScore: gameBoard.score > 0 && gameBoard.score == gameBoard.highScore
                    )
                    
                    ScoreView(
                        score: gameBoard.highScore,
                        title: "BEST",
                        isHighScore: true
                    )
                    
                    if gameBoard.score > 0 && gameBoard.score == gameBoard.highScore {
                        Text("New Record!")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue, .purple]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
            }
            
            // Buttons
            HStack(spacing: 16) {
                Button("New Game") {
                    withAnimation {
                        gameBoard.resetBoard()
                    }
                }
                .buttonStyle(GradientButtonStyle(backgroundColor: .blue))
                
                Button("Reset Best") {
                    showingHighScore = true
                }
                .buttonStyle(GradientButtonStyle(backgroundColor: .red))
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
