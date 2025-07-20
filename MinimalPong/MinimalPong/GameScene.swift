import SpriteKit
import SwiftUI

class GameScene: SKScene {
    var gameState: GameState?
    private var soundManager = SoundManager()
    
    // Game objects
    private var ball: SKShapeNode!
    private var leftPaddle: SKShapeNode!
    private var rightPaddle: SKShapeNode!
    private var centerLine: SKShapeNode!
    
    // Ball physics
    private var ballVelocity = CGVector(dx: 0, dy: 0)
    private let baseBallSpeed: CGFloat = 300
    
    // Paddle properties
    private let paddleSpeed: CGFloat = 400
    private let paddleWidth: CGFloat = 8
    private let paddleHeight: CGFloat = 80
    
    // Game state
    private var lastUpdateTime: TimeInterval = 0
    private var particles: [ParticleNode] = []
    
    // Input handling
    #if os(macOS)
    private var keysPressed: Set<String> = []
    #endif
    
    override func didMove(to view: SKView) {
        setupScene()
        setupGameObjects()
        resetBall()
    }
    
    private func setupScene() {
        backgroundColor = UIColor.white
        physicsWorld.gravity = CGVector.zero
        
        #if os(macOS)
        // Make the scene focusable for keyboard input
        view?.window?.makeFirstResponder(view)
        #endif
    }
    
    private func setupGameObjects() {
        // Center line
        centerLine = SKShapeNode(rect: CGRect(x: -1, y: -size.height/2, width: 2, height: size.height))
        centerLine.fillColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0)
        centerLine.strokeColor = .clear
        addChild(centerLine)
        
        // Ball
        ball = SKShapeNode(circleOfRadius: 12)
        ball.fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        ball.strokeColor = .clear
        addChild(ball)
        
        // Left paddle
        leftPaddle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: paddleWidth, height: paddleHeight))
        leftPaddle.fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        leftPaddle.strokeColor = .clear
        leftPaddle.position = CGPoint(x: -size.width/2 + 60, y: 0)
        addChild(leftPaddle)
        
        // Right paddle
        rightPaddle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: paddleWidth, height: paddleHeight))
        rightPaddle.fillColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        rightPaddle.strokeColor = .clear
        rightPaddle.position = CGPoint(x: size.width/2 - 60 - paddleWidth, y: 0)
        addChild(rightPaddle)
    }
    
    private func resetBall() {
        ball.position = CGPoint.zero
        
        // Random angle between -45 and 45 degrees
        let angle = CGFloat.random(in: -CGFloat.pi/4...CGFloat.pi/4)
        let speed = baseBallSpeed * CGFloat(gameState?.gameSpeed ?? 1.0)
        let direction = Bool.random() ? 1.0 : -1.0
        
        ballVelocity = CGVector(
            dx: cos(angle) * speed * direction,
            dy: sin(angle) * speed
        )
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard gameState?.currentScreen == .playing else { return }
        
        let deltaTime = lastUpdateTime == 0 ? 0 : currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        updatePaddles(deltaTime: deltaTime)
        updateBall(deltaTime: deltaTime)
        updateParticles(deltaTime: deltaTime)
    }
    
    private func updatePaddles(deltaTime: TimeInterval) {
        let moveDistance = paddleSpeed * CGFloat(deltaTime)
        
        // Left paddle controls
        #if os(macOS)
        if keysPressed.contains("w") {
            movePaddle(leftPaddle, by: moveDistance)
        }
        if keysPressed.contains("s") {
            movePaddle(leftPaddle, by: -moveDistance)
        }
        
        // Right paddle controls
        if gameState?.gameMode == .twoPlayer {
            if keysPressed.contains("ArrowUp") {
                movePaddle(rightPaddle, by: moveDistance)
            }
            if keysPressed.contains("ArrowDown") {
                movePaddle(rightPaddle, by: -moveDistance)
            }
        }
        #else
        // iOS touch controls
        if gameState?.leftPaddleUp == true {
            movePaddle(leftPaddle, by: moveDistance)
        }
        if gameState?.leftPaddleDown == true {
            movePaddle(leftPaddle, by: -moveDistance)
        }
        
        if gameState?.gameMode == .twoPlayer {
            if gameState?.rightPaddleUp == true {
                movePaddle(rightPaddle, by: moveDistance)
            }
            if gameState?.rightPaddleDown == true {
                movePaddle(rightPaddle, by: -moveDistance)
            }
        }
        #endif
        
        // AI for right paddle
        if gameState?.gameMode == .ai {
            updateAI(deltaTime: deltaTime)
        }
    }
    
    private func movePaddle(_ paddle: SKShapeNode, by distance: CGFloat) {
        let newY = paddle.position.y + distance
        let minY = -size.height/2 + paddleHeight/2
        let maxY = size.height/2 - paddleHeight/2
        paddle.position.y = max(minY, min(maxY, newY))
    }
    
    private func updateAI(deltaTime: TimeInterval) {
        let aiSpeed = paddleSpeed * 0.8 // Slightly slower for balanced gameplay
        let paddleCenter = rightPaddle.position.y + paddleHeight/2
        let ballY = ball.position.y
        let distance = ballY - paddleCenter
        
        // Only move if ball is coming towards AI and distance is significant
        if ballVelocity.dx > 0 && abs(distance) > 10 {
            let moveDistance = aiSpeed * CGFloat(deltaTime)
            if distance > 0 {
                movePaddle(rightPaddle, by: moveDistance)
            } else {
                movePaddle(rightPaddle, by: -moveDistance)
            }
        }
    }
    
    private func updateBall(deltaTime: TimeInterval) {
        // Move ball
        ball.position.x += ballVelocity.dx * CGFloat(deltaTime)
        ball.position.y += ballVelocity.dy * CGFloat(deltaTime)
        
        // Collision with top/bottom walls
        if ball.position.y + 12 >= size.height/2 || ball.position.y - 12 <= -size.height/2 {
            ballVelocity.dy = -ballVelocity.dy
            ball.position.y = max(-size.height/2 + 12, min(size.height/2 - 12, ball.position.y))
            soundManager.playWallHit()
            createParticles(at: ball.position, count: 3)
        }
        
        // Collision with paddles
        if checkPaddleCollision(leftPaddle) || checkPaddleCollision(rightPaddle) {
            gameState?.incrementRally()
            soundManager.playPaddleHit()
            createParticles(at: ball.position, count: 5)
        }
        
        // Scoring
        if ball.position.x < -size.width/2 {
            gameState?.scorePoint(for: "right")
            soundManager.playScore()
            createParticles(at: CGPoint(x: -size.width/2 + 50, y: ball.position.y), count: 8)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.resetBall()
            }
        } else if ball.position.x > size.width/2 {
            gameState?.scorePoint(for: "left")
            soundManager.playScore()
            createParticles(at: CGPoint(x: size.width/2 - 50, y: ball.position.y), count: 8)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.resetBall()
            }
        }
    }
    
    private func checkPaddleCollision(_ paddle: SKShapeNode) -> Bool {
        let paddleFrame = CGRect(
            x: paddle.position.x,
            y: paddle.position.y - paddleHeight/2,
            width: paddleWidth,
            height: paddleHeight
        )
        
        let ballFrame = CGRect(
            x: ball.position.x - 12,
            y: ball.position.y - 12,
            width: 24,
            height: 24
        )
        
        if paddleFrame.intersects(ballFrame) && 
           ((paddle == leftPaddle && ballVelocity.dx < 0) || 
            (paddle == rightPaddle && ballVelocity.dx > 0)) {
            
            // Calculate hit position on paddle (0 to 1)
            let relativeHitY = (ball.position.y - paddle.position.y) / paddleHeight
            let angle = relativeHitY * CGFloat.pi/3 // Max 60 degree angle
            
            let currentSpeed = sqrt(ballVelocity.dx * ballVelocity.dx + ballVelocity.dy * ballVelocity.dy)
            let newSpeed = currentSpeed * 1.02 * CGFloat(gameState?.gameSpeed ?? 1.0)
            
            let direction: CGFloat = paddle == leftPaddle ? 1 : -1
            ballVelocity = CGVector(
                dx: cos(angle) * newSpeed * direction,
                dy: sin(angle) * newSpeed
            )
            
            // Move ball out of paddle
            if paddle == leftPaddle {
                ball.position.x = paddle.position.x + paddleWidth + 12
            } else {
                ball.position.x = paddle.position.x - 12
            }
            
            return true
        }
        
        return false
    }
    
    private func createParticles(at position: CGPoint, count: Int) {
        for _ in 0..<count {
            let particle = ParticleNode()
            particle.position = CGPoint(
                x: position.x + CGFloat.random(in: -10...10),
                y: position.y + CGFloat.random(in: -10...10)
            )
            particles.append(particle)
            addChild(particle)
        }
    }
    
    private func updateParticles(deltaTime: TimeInterval) {
        particles.removeAll { particle in
            particle.update(deltaTime: deltaTime)
            if particle.isDead {
                particle.removeFromParent()
                return true
            }
            return false
        }
    }
    
    #if os(macOS)
    override func keyDown(with event: NSEvent) {
        keysPressed.insert(event.charactersIgnoringModifiers ?? "")
        
        if event.charactersIgnoringModifiers == "p" {
            if gameState?.currentScreen == .playing {
                gameState?.pauseGame()
            } else if gameState?.currentScreen == .paused {
                gameState?.resumeGame()
            }
        }
    }
    
    override func keyUp(with event: NSEvent) {
        keysPressed.remove(event.charactersIgnoringModifiers ?? "")
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    #endif
}

class ParticleNode: SKShapeNode {
    private var velocity: CGVector
    private var life: CGFloat
    private let maxLife: CGFloat = 30
    
    var isDead: Bool {
        return life <= 0
    }
    
    override init() {
        self.velocity = CGVector(
            dx: CGFloat.random(in: -100...100),
            dy: CGFloat.random(in: -100...100)
        )
        self.life = maxLife
        
        super.init()
        
        let rect = CGRect(x: -1, y: -1, width: 2, height: 2)
        self.path = CGPath(rect: rect, transform: nil)
        self.fillColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        self.strokeColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(deltaTime: TimeInterval) {
        position.x += velocity.dx * CGFloat(deltaTime)
        position.y += velocity.dy * CGFloat(deltaTime)
        
        life -= 1
        alpha = life / maxLife
    }
}