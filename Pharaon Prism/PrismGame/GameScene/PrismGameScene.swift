import Foundation
import SpriteKit
import SwiftUI

class PrismGameScene: SKScene {
    
    private var mover: SKSpriteNode!
    private var gamePauseBtn: SKSpriteNode!
    private var background: SKSpriteNode!
    private var gamePausedNode: GamePauseNode!
    
    private var backgroundMusic: SKAudioNode!
    
    private var levelLabel: SKLabelNode!
    
    private var gameFieldValues: [[Int]] = []
    private var gameCompletedValues: [[Int]] = []
    private var gameField: [[SKSpriteNode?]] = []
    private var currentPositionMover: (Int, Int) = (-1, -1) {
        didSet {
            let x = size.width / 1.5 - CGFloat(110 * currentPositionMover.1)
            let y = (size.height + 150) / 2 - CGFloat(currentPositionMover.0 * 110)
            let moveAction = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.5)
            mover.run(moveAction) {
                self.findBlockAndSetSelected()
            }
            if UserDefaults.standard.bool(forKey: "vibrationInApp") {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }
            soundBlock(view: mover)
        }
    }
    
    private var movesLabel: SKLabelNode!
    
    private var moves: Int = 0 {
        didSet {
            movesLabel.text = "\(moves)"
            if moves == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if UserDefaults.standard.bool(forKey: "vibrationInApp") {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error)
                    }
                    NotificationCenter.default.post(name: Notification.Name("LOSE"), object: nil, userInfo: nil)
                }
            }
        }
    }
    
    private var swipeDirection: SwipeDirection? = nil
    
    private var passedGame: Bool = false {
        didSet {
            if UserDefaults.standard.bool(forKey: "vibrationInApp") {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            drawGoodJob()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                NotificationCenter.default.post(name: Notification.Name("WIN"), object: nil, userInfo: nil)
            }
        }
    }
    
    var level: LevelItem! {
        didSet {
            if levelLabel != nil {
                levelLabel.text = "LEVEL \(level.num)"
                makeGameZone()
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 750, height: 1335)
        makeBackground()
        makeLevelLabel()
        makeMovesLabel()
        drawPauseBtn()
        makePauseNode()
        
        if level == nil {
            level = allLevels[0]
        } else {
            levelLabel.text = "LEVEL \(level.num)"
            makeGameZone()
        }
        
        let swipeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe))
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    private func makePauseNode() {
        gamePausedNode = GamePauseNode(color: .clear, size: size)
        gamePausedNode.zPosition = 15
        gamePausedNode.homeBtnAction = {
            NotificationCenter.default.post(name: Notification.Name("HOME"), object: nil, userInfo: nil)
        }
        gamePausedNode.playAction = {
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
            self.gamePausedNode.run(fadeOutAction) {
                self.gamePausedNode.removeFromParent()
            }
        }
        gamePausedNode.restartAction = {
            let newPrismGameScene = PrismGameScene()
            newPrismGameScene.level = self.level
            self.view?.presentScene(newPrismGameScene)
        }
    }
    
    private func drawPauseBtn() {
        gamePauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        gamePauseBtn.position = CGPoint(x: size.width / 2, y: 150)
        gamePauseBtn.size = CGSize(width: 100, height: 90)
        addChild(gamePauseBtn)
    }
    
    private func drawGoodJob() {
        let goodJobTitle = SKLabelNode(text: "GOOD JOB!")
        goodJobTitle.position = CGPoint(x: size.width / 2, y: 380)
        goodJobTitle.fontName = "KumarOne-Regular"
        goodJobTitle.fontSize = 72
        goodJobTitle.fontColor = .white
        goodJobTitle.zPosition = 12
        addChild(goodJobTitle)
    }
    
    private func makeTutor() {
        let arrowFirst = SKSpriteNode(imageNamed: "arrow_up")
        arrowFirst.position = CGPoint(x: size.width / 2 - 150, y: size.height / 2 - 80)
        addChild(arrowFirst)
        let arrowSecond = SKSpriteNode(imageNamed: "arrow_up")
        arrowSecond.position = CGPoint(x: size.width / 2 + 150, y: size.height / 2 - 80)
        addChild(arrowSecond)
        
        let tutorTitle = SKLabelNode(text: "SWIPE")
        tutorTitle.position = CGPoint(x: size.width / 2, y: 310)
        tutorTitle.fontName = "KumarOne-Regular"
        tutorTitle.fontSize = 62
        tutorTitle.fontColor = .white
        tutorTitle.zPosition = 12
        addChild(tutorTitle)
        let tutorTitle2 = SKLabelNode(text: "TO MOVE")
        tutorTitle2.position = CGPoint(x: size.width / 2, y: 230)
        tutorTitle2.fontName = "KumarOne-Regular"
        tutorTitle2.fontSize = 62
        tutorTitle2.fontColor = .white
        tutorTitle2.zPosition = 12
        addChild(tutorTitle2)
    }
    
    @objc func handleSwipe(sender: UIPanGestureRecognizer) {
        if moves > 0 {
            let translation = sender.translation(in: view)
                    
            if sender.state == .ended {
                if abs(translation.x) > abs(translation.y) {
                    if translation.x > 0 {
                        swipeDirection = .right
                    } else {
                        swipeDirection = .left
                    }
                } else {
                    if translation.y > 0 {
                        swipeDirection = .down
                    } else {
                        swipeDirection = .up
                    }
                }
                
                if let _ = swipeDirection {
                    moveMover()
                }
            }
        }
    }
    
    private func moveMover() {
        switch swipeDirection {
        case .up:
            if currentPositionMover.0 - 1 >= 0 && gameField[currentPositionMover.0 - 1][currentPositionMover.1] != nil {
                currentPositionMover = (currentPositionMover.0 - 1, currentPositionMover.1)
                moves -= 1
            }
        case .down:
            if currentPositionMover.0 + 1 <= 4 && gameField[currentPositionMover.0 + 1][currentPositionMover.1] != nil {
                currentPositionMover = (currentPositionMover.0 + 1, currentPositionMover.1)
                moves -= 1
            }
        case .left:
            if currentPositionMover.1 + 1 <= 4 && gameField[currentPositionMover.0][currentPositionMover.1 + 1] != nil {
                currentPositionMover = (currentPositionMover.0, currentPositionMover.1 + 1)
                moves -= 1
            }
        default:
            if currentPositionMover.1 - 1 >= 0 && gameField[currentPositionMover.0][currentPositionMover.1 - 1] != nil {
                currentPositionMover = (currentPositionMover.0, currentPositionMover.1 - 1)
                moves -= 1
            }
        }
        swipeDirection = nil
    }
    
    private func makeMovesLabel() {
        let movesTitle = SKLabelNode(text: "MOVES:")
        movesTitle.position = CGPoint(x: size.width / 2, y: size.height - 260)
        movesTitle.fontName = "KumarOne-Regular"
        movesTitle.fontSize = 42
        movesTitle.fontColor = .white
        addChild(movesTitle)
        
        movesLabel = SKLabelNode(text: "")
        movesLabel.position = CGPoint(x: size.width / 2, y: size.height - 330)
        movesLabel.fontName = "KumarOne-Regular"
        movesLabel.fontSize = 42
        movesLabel.fontColor = .white
        addChild(movesLabel)
    }
    
    private func placeMover() {
        mover = SKSpriteNode(imageNamed: "mover")
        let x = size.width / 1.5 - CGFloat(110 * level.starBlock.1)
        let y = (size.height + 150) / 2 - CGFloat(level.starBlock.0 * 110)
        mover.position = CGPoint(x: x, y: y)
        mover.size = CGSize(width: 110, height: 110)
        addChild(mover)
        currentPositionMover = level.starBlock
    }
    
    private func makeLevelLabel() {
        let levelBg = SKSpriteNode(imageNamed: "game_level_bg")
        levelBg.size = CGSize(width: size.width, height: 100)
        levelBg.position = CGPoint(x: size.width / 2, y: size.height - 145)
        addChild(levelBg)
        
        levelLabel = SKLabelNode(text: "")
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height - 160)
        levelLabel.fontName = "KumarOne-Regular"
        levelLabel.fontSize = 42
        levelLabel.fontColor = .white
        addChild(levelLabel)
    }
    
    private func makeBackground() {
        background = SKSpriteNode(imageNamed: "app_bg")
        background.size = CGSize(width: size.width, height: size.height)
        background.alpha = 0.6
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)
    }
    
    private func makeGameZone() {
        for (yIndex, row) in level.gameField.enumerated() {
            var rowNodes = [SKSpriteNode?]()
            var rpwValues: [Int] = []
            for (index, item) in row.enumerated() {
                if item == 1 {
                    let x = size.width / 1.5 - CGFloat(110 * index)
                    let y = (size.height + 150) / 2 - CGFloat(yIndex * 110)
                    var node: SKSpriteNode
                    if yIndex == level.starBlock.0 && index == level.starBlock.1 {
                        node = SKSpriteNode(imageNamed: "block_filled")
                        node.size = CGSize(width: 110, height: 110)
                    } else {
                        node = SKSpriteNode(imageNamed: "block_empty")
                        node.size = CGSize(width: 110, height: 110)
                    }
                    node.position = CGPoint(x: x, y: y)
                    node.name = "block_empty"
                    addChild(node)
                    rowNodes.append(node)
                    rpwValues.append(0)
                } else {
                    rowNodes.append(nil)
                    rpwValues.append(-1)
                }
            }
            gameFieldValues.append(rpwValues)
            gameField.append(rowNodes)
            gameCompletedValues.append([0,0,0,0,0,0])
        }
        placeMover()
        moves = level.moves
        if level.num == 1 {
            makeTutor()
        }
    }
    
    private func soundBlock(view: SKNode) {
        if UserDefaults.standard.bool(forKey: "soundInApp") {
            let audioNode = SKAction.playSoundFileNamed("block.mp3", waitForCompletion: false)
            view.run(audioNode)
        }
    }
    
    private func findBlockAndSetSelected() {
        let blockNode = gameField[currentPositionMover.0][currentPositionMover.1]
        if let blockNode = blockNode {
            let newTexture = SKTexture(imageNamed: "block_filled")
            blockNode.texture = newTexture
            blockNode.name = "block_filled"
            gameCompletedValues[currentPositionMover.0][currentPositionMover.1] = 1
            checkGameIfCompleted()
        }
    }
    
    private func checkGameIfCompleted() {
        for (x, nodesArr) in gameField.enumerated() {
            for (y, node) in nodesArr.enumerated() {
                if node != nil {
                    let blockCompletedValue = gameCompletedValues[x][y]
                    if blockCompletedValue == 0 {
                        return
                    }
                }
            }
        }
        passedGame = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
     
        guard !nodes(at: touch.location(in: self)).contains(gamePauseBtn) else {
            pauseGame()
            return
        }
    }
    
    private func pauseGame() {
        gamePausedNode.alpha = 0
        addChild(gamePausedNode)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        gamePausedNode.run(fadeInAction)
    }
    
}

enum SwipeDirection {
    case up, down, left, right, none
}

#Preview {
    VStack {
        SpriteView(scene: PrismGameScene())
            .ignoresSafeArea()
    }
}
