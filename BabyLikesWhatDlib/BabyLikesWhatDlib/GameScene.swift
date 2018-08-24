//
//  GameScene.swift
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-22.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    var viewController: GameViewController!

    private var label: SKLabelNode?
    var like1Node: SKSpriteNode?
    var like2Node: SKSpriteNode?
    var heart1Node: SKSpriteNode?
    var heart2Node: SKSpriteNode?
    var leftEyeNode: SKSpriteNode?
    var rightEyeNode: SKSpriteNode?
    var cameraNode: SKSpriteNode?
    var faceRectNode: SKSpriteNode?
    var r1LeftLabel = SKLabelNode()
    var r1RightLabel = SKLabelNode()
    var r2LeftLabel = SKLabelNode()
    var r2RightLabel = SKLabelNode()


    override func didMove(to view: SKView) {
        if SHOW_CORRELATION_BARS > 0 {
            r1LeftLabel = SKLabelNode(fontNamed: "Chalkduster")
            r1LeftLabel.text = "r1-left"
            r1LeftLabel.fontSize = 45
            r1LeftLabel.position = CGPoint(x: -600, y: 250)
            self.addChild(r1LeftLabel)
            r1RightLabel = SKLabelNode(fontNamed: "Chalkduster")
            r1RightLabel.text = "r1-right"
            r1RightLabel.fontSize = 45
            r1RightLabel.position = CGPoint(x:-400, y:250)
            self.addChild(r1RightLabel)

            r2LeftLabel = SKLabelNode(fontNamed: "Chalkduster")
            r2LeftLabel.text = "r2-left"
            r2LeftLabel.fontSize = 45
            r2LeftLabel.position = CGPoint(x: 400, y: 250)
            self.addChild(r2LeftLabel)
            r2RightLabel = SKLabelNode(fontNamed: "Chalkduster")
            r2RightLabel.text = "r2-right"
            r2RightLabel.fontSize = 45
            r2RightLabel.position = CGPoint(x: 600, y: 250)
            self.addChild(r2RightLabel)
        } else {
            for i in 0...5 {
                let l1 = self.childNode(withName: String(format: "//r1_left/r1l_%d", i + 1)) as! SKSpriteNode
                let r1 = self.childNode(withName: String(format: "//r1_right/r1r_%d", i + 1)) as! SKSpriteNode
                let l2 = self.childNode(withName: String(format: "//r2_left/r2l_%d", i + 1)) as! SKSpriteNode
                let r2 = self.childNode(withName: String(format: "//r2_right/r2r_%d", i + 1)) as! SKSpriteNode
                l1.removeFromParent();
                r1.removeFromParent();
                l2.removeFromParent();
                r2.removeFromParent();
            }
        }

        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

        self.like1Node = self.childNode(withName: "//Cpp") as? SKSpriteNode
        self.heart1Node = self.childNode(withName: "//CppHeart") as? SKSpriteNode
        if let likenode = self.like1Node {
            // Was 290 for y.
            let oscillate = SKAction.oscillation(amplitude_x: 800, amplitude_y: 0, timePeriod: 6, midPoint: CGPoint(x: self.frame.midX, y: 550))
            likenode.run(SKAction.repeatForever(oscillate))
        }

        self.like2Node = self.childNode(withName: "//Cat") as? SKSpriteNode
        self.heart2Node = self.childNode(withName: "//CatHeart") as? SKSpriteNode
        if let likenode = self.like2Node {
            let oscillate = SKAction.oscillation(amplitude_x: -800, amplitude_y: 0, timePeriod: 6, midPoint: CGPoint(x: self.frame.midX, y: -550))
            likenode.run(SKAction.repeatForever(oscillate))
        }

        self.leftEyeNode = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"))
        self.rightEyeNode = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"))
        self.leftEyeNode!.position.x = -600
        self.leftEyeNode!.position.y = 0
        self.rightEyeNode!.position.x = 600
        self.rightEyeNode!.position.y = 0
        self.addChild(leftEyeNode!)
        self.addChild(rightEyeNode!)

        if SHOW_CAMERA_AND_LANDMARKS > 0 {
            self.cameraNode = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"), size: CGSize(width: 850, height: 500))
            // self.cameraNode = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"), size: CGSize(width: 2000, height: 1300))
            self.cameraNode!.position.x = 0
            self.cameraNode!.position.y = 0
            self.cameraNode!.zPosition = 9
            self.addChild(cameraNode!)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.heart1Node!.alpha = CGFloat(self.viewController.r1_level) / 6.0
        self.heart2Node!.alpha = CGFloat(self.viewController.r2_level) / 6.0

        if SHOW_CORRELATION_BARS > 0 {
            for i in 0...5 {
                let l1 = self.childNode(withName: String(format: "//r1_left/r1l_%d", i + 1)) as! SKSpriteNode
                let r1 = self.childNode(withName: String(format: "//r1_right/r1r_%d", i + 1)) as! SKSpriteNode
                let l2 = self.childNode(withName: String(format: "//r2_left/r2l_%d", i + 1)) as! SKSpriteNode
                let r2 = self.childNode(withName: String(format: "//r2_right/r2r_%d", i + 1)) as! SKSpriteNode
                l1.alpha = viewController.r1_left[i] < 0 ? 0.1 : 1.0
                r1.alpha = viewController.r1_right[i] < 0 ? 0.1 : 1.0
                l2.alpha = viewController.r2_left[i] < 0 ? 0.1 : 1.0
                r2.alpha = viewController.r2_right[i] < 0 ? 0.1 : 1.0

                l1.xScale = viewController.r1_left[i]
                r1.xScale = viewController.r1_right[i]
                l2.xScale = viewController.r2_left[i]
                r2.xScale = viewController.r2_right[i]
            }
        }
    }
}


extension SKAction {
    static func oscillation(amplitude_x ax: CGFloat, amplitude_y ay: CGFloat, timePeriod t: CGFloat, midPoint: CGPoint) -> SKAction {
        let action = SKAction.customAction(withDuration: Double(t)) { node, currentTime in
            let o = 2.0 * CGFloat.pi * currentTime / t
            let displacement_x = ax * sin(o)
            let displacement_y = ay * cos(o)
            node.position.x = midPoint.x + displacement_x
            node.position.y = midPoint.y + displacement_y
        }

        return action
    }

}
