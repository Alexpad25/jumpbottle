//
//  MenuScene.swift
//  CloneBottleFlip
//
//  Created by Test on 18.09.17.
//  Copyright © 2017 Test. All rights reserved.
//

import SpriteKit

class MenuScene: SimpleScene {
    
    var playButtonNode = SKSpriteNode()
    var tableNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    var leftButtonNode = SKSpriteNode()
    var rightButtonNode = SKSpriteNode()
    var flipsTagNode = SKSpriteNode()
    var unlockLabelNode = SKLabelNode()
    
    
    var highscore = 0
    var totalFlips = 0
    var bottles = [Bottle]()
    var selectedBottleIndex = 0
    var totalBottles = 0
    var isShopButton = false
    
    var popSound = SKAction()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UI_BACKGROUND_COLOR
        
        //Loading bottles form Items.plist
        bottles = BottleController.readItems()
        totalBottles = bottles.count
        
        //Get total flips
        highscore = UserDefaults.standard.integer(forKey: "localHighscore")
        totalFlips = UserDefaults.standard.integer(forKey: "flips")
        
        
        popSound = SKAction.playSoundFileNamed(GAME_SOUND_POP, waitForCompletion: false)
        
        setupUI()
    }
    
    func setupUI() {
        
        //Logo Node
        let logo = ButtonNode(imageNode: "logo", position: CGPoint(x: self.frame.midX, y: self.frame.maxY - 75), xScale: 1, yScale: 1)
        self.addChild(logo)
        
        //Best Score Label
        let bestScoreLabelNode = LabelNode(text: "ЛУЧШИЙ РЕЗУЛЬТАТ", fontSize: 15, position: CGPoint(x: self.frame.midX - 100, y: self.frame.maxY - 165), fontColor: #colorLiteral(red: 0.755852282, green: 0.3456354439, blue: 0.3465844691, alpha: 1))
        self.addChild(bestScoreLabelNode)
        
        //High Score Label
        let highScoreLabelNode = LabelNode(text: String(highscore), fontSize: 70, position: CGPoint(x: self.frame.midX - 100, y: self.frame.maxY - 235), fontColor: #colorLiteral(red: 0.755852282, green: 0.3456354439, blue: 0.3465844691, alpha: 1))
        self.addChild(highScoreLabelNode)
        
        //Total Flips Label
        let totalFlipsLabelNode = LabelNode(text: "КОЛИЧЕСТВО САЛЬТ", fontSize: 15, position: CGPoint(x: self.frame.midX + 100, y: self.frame.maxY - 165), fontColor: #colorLiteral(red: 0.1411150396, green: 0.2318876982, blue: 0.6653875709, alpha: 1))
        self.addChild(totalFlipsLabelNode)
        
        //Total Flips Score Label
        let flipsLabelNode = LabelNode(text: String(totalFlips), fontSize: 70, position: CGPoint(x: self.frame.midX + 100, y: self.frame.maxY - 235), fontColor: #colorLiteral(red: 0.1411150396, green: 0.2318876982, blue: 0.6653875709, alpha: 1))
        self.addChild(flipsLabelNode)
        
        //Play button
        playButtonNode = ButtonNode(imageNode: "play_button", position: CGPoint(x: self.frame.midX, y: self.frame.midY - 15), xScale: 0.9, yScale: 0.9)
        self.addChild(playButtonNode)
        
        //Table node
        tableNode = ButtonNode(imageNode: "table", position: CGPoint(x: self.frame.midX, y: self.frame.minY + 29), xScale: 0.45, yScale: 0.45)
        tableNode.zPosition = 3
        self.addChild(tableNode)
        
        //Bottle node
        selectedBottleIndex = BottleController.getSaveBottleIndex()
        let selectedBottle = bottles[selectedBottleIndex]
        
        bottleNode = SKSpriteNode(imageNamed: selectedBottle.Sprite!)
        bottleNode.zPosition = 10
        self.addChild(bottleNode)
        
        //Left button
        leftButtonNode = ButtonNode(imageNode: "left_button", position: CGPoint(x: self.frame.midX + leftButtonNode.size.width - 130, y: self.frame.minY - leftButtonNode.size.height + 145), xScale: 0.8, yScale: 0.8)
        self.changeButton(leftButtonNode, state: false)
        self.addChild(leftButtonNode)
        
        //Right button
        rightButtonNode = ButtonNode(imageNode: "right_button", position: CGPoint(x: self.frame.midX + rightButtonNode.size.width + 130, y: self.frame.minY - rightButtonNode.size.height + 145), xScale: 0.8, yScale: 0.8)
        self.changeButton(rightButtonNode, state: true)
        self.addChild(rightButtonNode)
        
        //Lock Node
        flipsTagNode = ButtonNode(imageNode: "lock", position: CGPoint(x: self.frame.midX + bottleNode.size.width * 0.25, y: self.frame.minY + bottleNode.size.height/2 + 94), xScale: 0.5, yScale: 0.5)
        flipsTagNode.zPosition = 25
        flipsTagNode.zRotation = 0.3
        self.addChild(flipsTagNode)
        
        //Unlock Label
        unlockLabelNode = LabelNode(text: "0", fontSize: 36, position: CGPoint(x: 0, y: -unlockLabelNode.frame.size.height + 25), fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        unlockLabelNode.zPosition = 30
        flipsTagNode.addChild(unlockLabelNode)
        
        //Update selected bottle
        self.updateSelectedBottle(selectedBottle)
        
        self.pulseLockNode(flipsTagNode)
    }
    
    func changeButton(_ buttonNode: SKSpriteNode, state: Bool) {
        //Change arrow sprites
        var buttonColor = #colorLiteral(red: 0.3411764706, green: 0.3529411765, blue: 0.4431372549, alpha: 0.2024026113)
        
        if state {
            buttonColor = #colorLiteral(red: 0.3411764706, green: 0.3529411765, blue: 0.4431372549, alpha: 1)
        }
        
        buttonNode.color = buttonColor
        buttonNode.colorBlendFactor = 1
    }
    
    func updateSelectedBottle(_ bottle: Bottle) {
        
        //Update to the selected bottle
        let unclockFlips = bottle.MinFlips!.intValue - highscore
        let unlocked = (unclockFlips <= 0)
        
        flipsTagNode.isHidden = unlocked
        unlockLabelNode.isHidden = unlocked
        
        bottleNode.texture = SKTexture(imageNamed: bottle.Sprite!)
        playButtonNode.texture = SKTexture(imageNamed: (unlocked ? "play_button" : "shop_button"))
        
        isShopButton = !unlocked
        
        bottleNode.size = CGSize(width: bottleNode.texture!.size().width * CGFloat(bottle.XScale!.floatValue), height: bottleNode.texture!.size().height * CGFloat(bottle.YScale!.floatValue))
        
        bottleNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + bottleNode.size.height/2 + 94)
        
        flipsTagNode.position = CGPoint(x: self.frame.midX + bottleNode.size.width * 0.25, y: self.frame.minY + bottleNode.size.height/2 + 94)
        
        unlockLabelNode.text = "\(bottle.MinFlips!.intValue)"
        unlockLabelNode.position = CGPoint(x: 0, y: -unlockLabelNode.frame.size.height + 25)
        
        self.updateArrowsState()
    }
    
    func updateArrowsState() {
        //Update arrows states
        self.changeButton(leftButtonNode, state: Bool(truncating: selectedBottleIndex as NSNumber))
        self.changeButton(rightButtonNode, state: selectedBottleIndex != totalBottles - 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            //Play button is pressed
            if playButtonNode.contains(location) {
                self.playSoundFX(popSound)
                self.startGame()
            }
            
            //Left button is pressed
            if leftButtonNode.contains(location) {
                let prevIndex = selectedBottleIndex - 1
                if prevIndex >= 0 {
                    self.playSoundFX(popSound)
                    self.updateByIndex(prevIndex)
                }
            }
            
            //Right button is pressed
            if rightButtonNode.contains(location) {
                let nextIndex = selectedBottleIndex + 1
                if nextIndex < totalBottles {
                    self.playSoundFX(popSound)
                    self.updateByIndex(nextIndex)
                }
            }
            
        }
    }
    
    func updateByIndex(_ index: Int) {
        //Update based on index
        let bottle = bottles[index]
        
        selectedBottleIndex = index
        
        self.updateSelectedBottle(bottle)
        BottleController.saveSelectedBottle(selectedBottleIndex)
    }
    
    func pulseLockNode(_ node: SKSpriteNode) {
        //Pulse animation for lock
        let scaleDownAction = SKAction.scale(to: 0.35, duration: 0.5)
        let scaleUpAction = SKAction.scale(to: 0.5, duration: 0.5)
        let seq = SKAction.sequence([scaleDownAction, scaleUpAction])
        
        node.run(SKAction.repeatForever(seq))
    }
    
    func startGame() {
        //Not shop button, so start game
        if !isShopButton {
            let userData: NSMutableDictionary = ["bottle": bottles[selectedBottleIndex]]
            self.changeToSceneBy(nameScene: "GameScene", userData: userData)
            
        } else {
            //Start in-App Purchase
            print("Start iAP")
        }
    }
    
}
