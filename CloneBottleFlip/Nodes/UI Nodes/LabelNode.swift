//
//  LabelNode.swift
//  CloneBottleFlip
//
//  Created by Test on 18.09.17.
//  Copyright © 2017 Test. All rights reserved.
//

import SpriteKit

class LabelNode: SKLabelNode {
    
    convenience init(text: String, fontSize: CGFloat, position: CGPoint, fontColor: UIColor) {
        self.init(fontNamed: UI_FONT)
        self.text = text
        self.fontSize = fontSize
        self.position = position
        self.fontColor = fontColor
    }
    
}
