//
//  GamoeOverScene.swift
//  ArrowTest
//
//  Created by Andrey Petrovskiy on 9/8/19.
//  Copyright © 2019 Andrey Petrovskiy. All rights reserved.
//

import SpriteKit

class GameOverScene: GameScene {
    
    init(size: CGSize, loose: Bool) {
        super.init(size: size)
        
        backgroundColor = SKColor.black
        
        let message = loose ?  "You Lose :[":"You Won!"
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() { [weak self] in
                // 5
                guard let self = self else { return }
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
