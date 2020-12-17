//
//  SimpleScene.swift
//  CloneBottleFlip
//
//  Created by Test on 18.09.17.
//  Copyright © 2017 Test. All rights reserved.
//

import SpriteKit

class SimpleScene: SKScene {
    
    func changeToSceneBy(nameScene: String, userData: NSMutableDictionary) {
        //Change to scene
        let scene = (nameScene == "GameScene") ? GameScene(size: self.size) : MenuScene(size: self.size)
        
        let transition = SKTransition.fade(with: UI_BACKGROUND_COLOR, duration: 0.3)
        
        scene.scaleMode = .aspectFill
        scene.userData = userData
        
        self.view?.presentScene(scene, transition: transition)
    }
    
    
    func playSoundFX(_ action: SKAction) {
        self.run(action)
    }
}



