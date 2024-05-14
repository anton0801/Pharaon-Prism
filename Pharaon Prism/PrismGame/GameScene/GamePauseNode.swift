import Foundation
import SpriteKit

class GamePauseNode: SKSpriteNode {
    
    var background: SKSpriteNode!
    
    private var homeBtn: SKSpriteNode!
    private var playBtn: SKSpriteNode!
    private var restartBtn: SKSpriteNode!
    
    var homeBtnAction: (() -> Void)?
    var playAction: (() -> Void)?
    var restartAction: (() -> Void)?
    
    init(color: UIColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        isUserInteractionEnabled = true
        
        let backBlack = SKSpriteNode(color: .black, size: size)
        backBlack.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backBlack)
        
        background = SKSpriteNode(imageNamed: "app_bg")
        background.size = size
        background.alpha = 0.4
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)
        
        let pauseTitle = SKLabelNode(text: "PAUSE")
        pauseTitle.fontName = "KumarOne-Regular"
        pauseTitle.fontSize = 72
        pauseTitle.fontColor = .white
        pauseTitle.position = CGPoint(x: size.width / 2, y: size.height - 200)
        addChild(pauseTitle)
        
        let gamePaused = SKLabelNode(text: "GAME PAUSED")
        gamePaused.fontName = "KumarOne-Regular"
        gamePaused.fontSize = 62
        gamePaused.fontColor = .white
        gamePaused.position = CGPoint(x: size.width / 2, y: size.height - 500)
        addChild(gamePaused)
        
        homeBtn = SKSpriteNode(imageNamed: "home_btn")
        homeBtn.position = CGPoint(x: size.width / 2 - 190, y: size.height / 2 - 100)
        homeBtn.size = CGSize(width: 180, height: 160)
        addChild(homeBtn)
        
        playBtn = SKSpriteNode(imageNamed: "play_btn")
        playBtn.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        playBtn.size = CGSize(width: 180, height: 160)
        addChild(playBtn)
        
        restartBtn = SKSpriteNode(imageNamed: "restart_btn")
        restartBtn.position = CGPoint(x: size.width / 2 + 190, y: size.height / 2 - 100)
        restartBtn.size = CGSize(width: 180, height: 160)
        addChild(restartBtn)
        
        let pharaon = SKSpriteNode(imageNamed: "pharaon_1")
        pharaon.position = CGPoint(x: size.width / 2, y: 150)
        addChild(pharaon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let objects = nodes(at: location)

        guard !objects.contains(homeBtn) else {
            homeBtnAction?()
            return
        }
        
        guard !objects.contains(playBtn) else {
            playAction?()
            return
        }
        
        guard !objects.contains(restartBtn) else {
            restartAction?()
            return
        }
    }
    
}
