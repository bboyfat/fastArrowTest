//
//  GameViewController.swift
//  ArrowTest
//
//  Created by Andrey Petrovskiy on 9/7/19.
//  Copyright © 2019 Andrey Petrovskiy. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

    
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
   
}
