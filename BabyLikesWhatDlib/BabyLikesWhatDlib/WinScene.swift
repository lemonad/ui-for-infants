//
//  GameScene.swift
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-22.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

import SpriteKit
import GameplayKit


class WinScene: SKScene {
    var viewController: GameViewController!

    private var label: SKLabelNode?
    var loved = 0
    var like1Node: SKSpriteNode?
    var like2Node: SKSpriteNode?
    var heartNode: SKSpriteNode?
    var percent1Node: SKSpriteNode?
    var percent2Node: SKSpriteNode?
    var cameraNode: SKSpriteNode?

    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        self.heartNode = self.childNode(withName: "//Heart") as? SKSpriteNode
        self.like1Node = self.childNode(withName: "//Cpp") as? SKSpriteNode
        self.like2Node = self.childNode(withName: "//Cat") as? SKSpriteNode
        like1Node?.alpha = 0
        like2Node?.alpha = 0

        if loved == 1 {
            like1Node?.run(SKAction.fadeIn(withDuration: 1.0))
        } else {
            like2Node?.run(SKAction.fadeIn(withDuration: 1.0))
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

