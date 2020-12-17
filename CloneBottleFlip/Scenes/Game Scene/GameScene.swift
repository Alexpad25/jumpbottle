//
//  GameScene.swift
//  CloneBottleFlip
//
//  Created by Test on 18.09.17.
//  Copyright © 2017 Test. All rights reserved.
//

import SpriteKit

class GameScene: SimpleScene {
    
    var scoreLabelNode = SKLabelNode()
    var highscoreLabelNode = SKLabelNode()
    var backButtonNode = SKSpriteNode()
    var resetButtonNode = SKSpriteNode()
    var tutorialNode = SKSpriteNode()
    var bottleNode = SKSpriteNode()
    
    var didSwipe = false
    var start = CGPoint.zero
    var startTime = TimeInterval()
    var currentScore = 0
    
    var popSound = SKAction()
    var failSound = SKAction()
    var winSound = SKAction()
    
    override func didMove(to view: SKView) {
        //Setting the scene
        self.physicsBody?.restitution = 0
        self.backgroundColor = UI_BACKGROUND_COLOR
        
        self.setupUINodes()
        self.setupGameNodes()
        
        popSound = SKAction.playSoundFileNamed(GAME_SOUND_POP, waitForCompletion: false)
        failSound = SKAction.playSoundFileNamed(GAME_SOUND_FAIL, waitForCompletion: false)
        winSound = SKAction.playSoundFileNamed(GAME_SOUND_SUCCESS, waitForCompletion: false)
    }
    
    func setupUINodes() {
        //Score label node
        scoreLabelNode = LabelNode(text: "0", fontSize: 140, position: CGPoint(x: self.frame.midX, y: self.frame.midY), fontColor: #colorLiteral(red: 0.5646123749, green: 0.5834830091, blue: 0.8582356771, alpha: 0.6021243579))
        scoreLabelNode.zPosition = -1
        self.addChild(scoreLabelNode)
        
        //High score label node
        highscoreLabelNode = LabelNode(text: "НОВЫЙ РЕЗУЛЬТАТ", fontSize: 32, position: CGPoint(x: self.frame.midX, y: self.frame.midY - 40), fontColor: #colorLiteral(red: 0.5646123749, green: 0.5834830091, blue: 0.8582356771, alpha: 0.6021243579))
        highscoreLabelNode.isHidden = true
        highscoreLabelNode.zPosition = -1
        self.addChild(highscoreLabelNode)
        
        //Back button
        backButtonNode = ButtonNode(imageNode: "back_button", position: CGPoint(x: self.frame.minX + backButtonNode.size.width + 30, y: self.frame.maxY - backButtonNode.size.height - 40), xScale: 0.65, yScale: 0.65)
        self.addChild(backButtonNode)
        
        //Reset button
        resetButtonNode = ButtonNode(imageNode: "reset_button", position: CGPoint(x: self.frame.maxX - resetButtonNode.size.width - 40, y: self.frame.maxY - resetButtonNode.size.height - 40), xScale: 0.65, yScale: 0.65)
        self.addChild(resetButtonNode)
        
        //Tutorial button
        let tutorialFinished = UserDefaults.standard.bool(forKey: "tutorialFinished")
        tutorialNode = ButtonNode(imageNode: "tutorial", position: CGPoint(x: self.frame.midX, y: self.frame.midY), xScale: 0.55, yScale: 0.55)
        tutorialNode.zPosition = 5
        tutorialNode.isHidden = tutorialFinished
        self.addChild(tutorialNode)
    }
    
    func setupGameNodes() {
        //Table node
        let tableNode = SKSpriteNode(imageNamed: "table")
        
        tableNode.physicsBody = SKPhysicsBody(rectangleOf: (tableNode.texture?.size())!)
        tableNode.physicsBody?.affectedByGravity = false
        tableNode.physicsBody?.isDynamic = false
        tableNode.physicsBody?.restitution = 0
        tableNode.xScale = 0.45
        tableNode.yScale = 0.45
        tableNode.position = CGPoint(x: self.frame.midX, y: 29)
        self.addChild(tableNode)
        
        //Bottle Node
        let selectedBottle = self.userData?.object(forKey: "bottle")
        bottleNode = BottleNode(selectedBottle as! Bottle)
        self.addChild(bottleNode)
        
        self.resetBottle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Start recording touches
        if touches.count > 1 {
            return
        }
        
        let touch = touches.first
        let location = touch!.location(in: self)
        
        start = location
        startTime = touch!.timestamp
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if backButtonNode.contains(location) {
                self.playSoundFX(popSound)
                self.changeToSceneBy(nameScene: "MenuScene", userData: NSMutableDictionary.init())
            }
            
            if ((resetButtonNode.contains(location)) && didSwipe == true) {
                self.playSoundFX(popSound)
                failedFlip()
            }
            
            if tutorialNode.contains(location) {
                tutorialNode.isHidden = true
                UserDefaults.standard.set(true, forKey: "tutorialFinished")
                UserDefaults.standard.synchronize()
            }
        }
        
        //Bottle flipping logic
        if !didSwipe {
            //Скорость = расстояние/время
            //Расстояние = sqrt(x*x+y*y)
            //x = Хк - Хн
            let touch = touches.first
            let location = touch?.location(in: self) //Хк
            
            let x = ceil(location!.x - start.x)
            let y = ceil(location!.y - start.y)
            
            let distance = sqrt(x*x + y*y)
            
            let time = CGFloat(touch!.timestamp - startTime)
            
            if (distance >= GAME_SWIPE_MIN_DISTANCE && y > 0) {
                let speed = distance / time
                
                if speed >= GAME_SWIPE_MIN_SPEED {
                    //Add angular velocity and impulse
                    bottleNode.physicsBody?.angularVelocity = GAME_ANGULAR_VELOCITY
                    bottleNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: distance * GAME_DISTANCE_MULTIPLIER))
                    didSwipe = true
                }
            }
        }
    }
    
    func failedFlip() {
        //Failed flips, reset score and bottle
        self.playSoundFX(failSound)
        currentScore = 0
        
        self.updateScore()
        self.resetBottle()
    }
    
    func resetBottle() {
        //Reset bottle after a failed or successful flip
        bottleNode.position = CGPoint(x: self.frame.midX, y: bottleNode.size.height)
        bottleNode.physicsBody?.angularVelocity = 0
        bottleNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bottleNode.speed = 0
        bottleNode.zRotation = 0
        didSwipe = false
        
        self.playSoundFX(popSound)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        self.checkIfSuccessfulFlip()
    }
    
    func checkIfSuccessfulFlip() {
        if (bottleNode.position.x <= 0 || bottleNode.position.x >= self.frame.size.width || bottleNode.position.y <= 0) {
            self.failedFlip()
        }
        
        if (didSwipe && bottleNode.physicsBody!.isResting) {
            let bottleRotation = fabs(Float(bottleNode.zRotation))
            
            if bottleRotation > 0 && bottleRotation < 0.05 {
                self.successFlip()
            } else {
                self.failedFlip()
            }
        }
    }
    
    func successFlip() {
        //Successfilly flipped, so update scores & reset bottles
        self.playSoundFX(winSound)
        self.updateFlips()
        
        currentScore += 1
        
        self.updateScore()
        self.resetBottle()
    }
    
    func updateScore() {
        //Updating score based on flips and saving highscore
        scoreLabelNode.text = "\(currentScore)"
        
        let localHighscore = UserDefaults.standard.integer(forKey: "localHighscore")
        
        if currentScore > localHighscore {
            highscoreLabelNode.isHidden = false
            
            let fadeAction = SKAction.fadeAlpha(to: 0, duration: 1.0)
            
            highscoreLabelNode.run(fadeAction, completion: {
                self.highscoreLabelNode.isHidden = true
            })
            
            UserDefaults.standard.set(currentScore, forKey: "localHighscore")
            UserDefaults.standard.synchronize()
        }
    }
    
    func updateFlips() {
        //Update total flips
        var flips = UserDefaults.standard.integer(forKey: "flips")
        
        flips += 1
        UserDefaults.standard.set(flips, forKey: "flips")
        UserDefaults.standard.synchronize()
    }
}
