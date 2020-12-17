//
//  ButtonNode.swift
//  CloneBottleFlip
//
//  Created by Test on 18.09.17.
//  Copyright © 2017 Test. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    
    var originalScale: CGFloat = 0
    
    init(imageNode: String, position: CGPoint, xScale: CGFloat, yScale: CGFloat) {
        
        let texture = SKTexture(imageNamed: imageNode)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.position = position
        self.xScale = xScale
        self.yScale = yScale
        self.originalScale = xScale
        
        buttonAnimation()
    }
    
    func buttonAnimation() {
        let scaleDownAction = SKAction.scale(to: 0, duration: 0)
        let scaleUpAction = SKAction.scale(to: originalScale, duration: 1.0)
        let seq = SKAction.sequence([scaleDownAction, scaleUpAction])
        
        self.run(seq)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
