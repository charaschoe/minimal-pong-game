import SwiftUI
import Combine

enum GameScreen {
    case start
    case playing
    case paused
    case gameOver
}

enum GameMode {
    case twoPlayer
    case ai
}

class GameState: ObservableObject {
    @Published var currentScreen: GameScreen = .start
    @Published var gameMode: GameMode = .twoPlayer
    @Published var winningScore: Int = 10
    @Published var leftScore: Int = 0
    @Published var rightScore: Int = 0
    @Published var rally: Int = 0
    @Published var gameSpeed: Double = 1.0
    @Published var winner: String = ""
    
    // Touch controls for iOS
    @Published var leftPaddleUp: Bool = false
    @Published var leftPaddleDown: Bool = false
    @Published var rightPaddleUp: Bool = false
    @Published var rightPaddleDown: Bool = false
    
    func startGame() {
        currentScreen = .playing
        resetGame()
    }
    
    func pauseGame() {
        currentScreen = .paused
    }
    
    func resumeGame() {
        currentScreen = .playing
    }
    
    func endGame(winner: String) {
        self.winner = winner
        currentScreen = .gameOver
    }
    
    func resetGame() {
        leftScore = 0
        rightScore = 0
        rally = 0
        gameSpeed = 1.0
    }
    
    func showMenu() {
        currentScreen = .start
    }
    
    func scorePoint(for player: String) {
        if player == "left" {
            leftScore += 1
        } else {
            rightScore += 1
        }
        
        rally = 0
        gameSpeed = 1.0
        
        if leftScore >= winningScore {
            endGame(winner: gameMode == .ai ? "You Win!" : "Player 1 Wins!")
        } else if rightScore >= winningScore {
            endGame(winner: gameMode == .ai ? "AI Wins!" : "Player 2 Wins!")
        }
    }
    
    func incrementRally() {
        rally += 1
        if rally % 5 == 0 {
            gameSpeed = min(2.0, gameSpeed + 0.1)
        }
    }
}