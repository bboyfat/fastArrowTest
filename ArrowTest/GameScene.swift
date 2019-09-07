//
//  GameScene.swift
//  ArrowTest
//
//  Created by Andrey Petrovskiy on 9/7/19.
//  Copyright © 2019 Andrey Petrovskiy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    struct PhysicalCategory {
        static let none: UInt32 = 0
        static let all: UInt32 = UInt32.max
        static let shootingArrow: UInt32 = 0b1
        static let target: UInt32 = 0b10
       
    }
    
    var score = 0 {
        didSet {
            
            scoreLbl.text = "Score: \(score)"
            
        }
    }
    
    
    
    let scoreLbl = SKLabelNode(text: "Score: 0")
    let arrow = SKSpriteNode(imageNamed: "arrow")
    let backgroundImage = SKSpriteNode(imageNamed: "background")
    
    override func didMove(to view: SKView) {
        
        arrow.position = CGPoint(x: size.width / 2, y: arrow.size.height)
        backgroundImage.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundImage.zPosition = -1
        scoreLbl.position = CGPoint(x: 100, y: size.height - 60)
        scoreLbl.fontSize = 25
        scoreLbl.fontColor = SKColor.orange
        addChild(backgroundImage)
        addChild(arrow)
        addChild(scoreLbl)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run {
                self.arrow.alpha = 1
            },
            SKAction.run({
                self.addTarget()
            }),
            SKAction.wait(forDuration: 2.0)
            ])))
    }
    
    func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        shot()
        
    }
    
    func shot() {
        
        let shootingArrow = SKSpriteNode(imageNamed: "arrow")
        shootingArrow.position = arrow.position
        shootingArrow.physicsBody = SKPhysicsBody(circleOfRadius: shootingArrow.size.width/2)
        shootingArrow.physicsBody?.isDynamic = true
        shootingArrow.physicsBody?.categoryBitMask = PhysicalCategory.shootingArrow
        shootingArrow.physicsBody?.contactTestBitMask = PhysicalCategory.target
        shootingArrow.physicsBody?.collisionBitMask = PhysicalCategory.none
        shootingArrow.physicsBody?.usesPreciseCollisionDetection = true
        
        
        addChild(shootingArrow)
        
        let moveAction = SKAction.move(to: CGPoint(x: arrow.position.x, y: size.height + shootingArrow.size.height), duration: 1.0)
        let moveActionDone = SKAction.removeFromParent()
        
        shootingArrow.run(SKAction.sequence([moveAction, moveActionDone]))
        arrow.alpha = 0.5
        
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        
        return random() * (max - min) + min
        
    }
    
    func addTarget() {
        
        let target = SKSpriteNode(imageNamed: "target")
        
        let actualY = random(min: arrow.size.height + 100, max: size.height - 50)
        target.position = CGPoint(x: 0, y: actualY)
        
        target.physicsBody = SKPhysicsBody(rectangleOf: target.size)
        target.physicsBody?.isDynamic = false
        target.physicsBody?.mass = 1.0
        target.physicsBody?.categoryBitMask = PhysicalCategory.target
        target.physicsBody?.contactTestBitMask = PhysicalCategory.shootingArrow
        target.physicsBody?.collisionBitMask = PhysicalCategory.none
        
        
        addChild(target)
        
        let randomDuration = random(min: CGFloat(4.0), max: CGFloat(6.0))
        
        let moveAction = SKAction.move(to: CGPoint(x: size.width + target.size.width, y: actualY),
                                       duration: TimeInterval(randomDuration))
        
        let moveActionDone = SKAction.removeFromParent()
        
        target.run(SKAction.sequence([moveAction, moveActionDone]))
        
    }
    
    func didShot(shootingArrow: SKSpriteNode, target: SKSpriteNode) {
        print("SHOT")
       
        score += 2
        
        shootingArrow.physicsBody?.pinned = true
        let a = SKPhysicsJointPin.joint(withBodyA: target.physicsBody! , bodyB: shootingArrow.physicsBody!, anchor: CGPoint(x: target.position.x, y: 0))
        self.physicsWorld.add(a)
        
        if score > 10 {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, loose: false)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
   
}




extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicalCategory.shootingArrow != 0) && (secondBody.categoryBitMask & PhysicalCategory.target) != 0) {
            if let shootingArrow = firstBody.node as? SKSpriteNode,
                let target = secondBody.node as? SKSpriteNode {
                self.didShot(shootingArrow: shootingArrow, target: target)
            }
        }
        
    }
    
}
