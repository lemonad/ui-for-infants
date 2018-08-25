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
    var eyeLabel: SKLabelNode?
    var like1Node: SKSpriteNode?
    var like2Node: SKSpriteNode?
    var heart1Node: SKSpriteNode?
    var heart2Node: SKSpriteNode?
    var percent1Node: SKSpriteNode?
    var percent2Node: SKSpriteNode?
    var cameraNode: SKSpriteNode?
    var faceRectNode: SKSpriteNode?
    var r1LeftLabel = SKLabelNode()
    var r1RightLabel = SKLabelNode()
    var r2LeftLabel = SKLabelNode()
    var r2RightLabel = SKLabelNode()


    override func didMove(to view: SKView) {
        let upArrowPath = UIBezierPath()
        upArrowPath.move(to: CGPoint(x: 9.5, y: 313.5))
        upArrowPath.addCurve(to: CGPoint(x: 129.5, y: 232.5), controlPoint1: CGPoint(x: 9.5, y: 313.5), controlPoint2: CGPoint(x: 91.5, y: 313.5))
        upArrowPath.addCurve(to: CGPoint(x: 105.5, y: 89.5), controlPoint1: CGPoint(x: 167.5, y: 151.5), controlPoint2: CGPoint(x: 122.5, y: 99.5))
        upArrowPath.addCurve(to: CGPoint(x: 53.5, y: 149.5), controlPoint1: CGPoint(x: 88.5, y: 79.5), controlPoint2: CGPoint(x: 35.5, y: 76.5))
        upArrowPath.addCurve(to: CGPoint(x: 211.5, y: 180.5), controlPoint1: CGPoint(x: 71.5, y: 222.5), controlPoint2: CGPoint(x: 155.5, y: 225.5))
        upArrowPath.addCurve(to: CGPoint(x: 284.5, y: -47.5), controlPoint1: CGPoint(x: 267.5, y: 135.5), controlPoint2: CGPoint(x: 284.5, y: -47.5))
        upArrowPath.apply(CGAffineTransform(translationX: -9.5, y: -313.5))
        upArrowPath.apply(CGAffineTransform(scaleX: 1, y: -1))

        let downArrowPath = UIBezierPath()
        downArrowPath.move(to: CGPoint(x: 281.5, y: 141.5))
        downArrowPath.addCurve(to: CGPoint(x: 6.5, y: 364.5), controlPoint1: CGPoint(x: 150.5, y: 135.5), controlPoint2: CGPoint(x: 54.5, y: 157.5))
        downArrowPath.apply(CGAffineTransform(translationX: -281.5, y: -141.5))
        downArrowPath.apply(CGAffineTransform(scaleX: 1, y: -1))

        eyeLabel = self.childNode(withName: "//Eyes") as? SKLabelNode
        eyeLabel?.alpha = 0

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
            let oscillate = SKAction.oscillation(amplitudeX: 800, amplitudeY: 0, timePeriod: 6, midPoint: CGPoint(x: self.frame.midX, y: 550), offset: 1 * CGFloat.pi) // 1.4
            likenode.run(SKAction.repeatForever(oscillate))
        }

        self.like2Node = self.childNode(withName: "//Cat") as? SKSpriteNode
        self.heart2Node = self.childNode(withName: "//CatHeart") as? SKSpriteNode
        if let likenode = self.like2Node {
            let oscillate = SKAction.oscillation(amplitudeX: 800, amplitudeY: 0, timePeriod: 6, midPoint: CGPoint(x: self.frame.midX, y: -550), offset: 0)
            likenode.run(SKAction.repeatForever(oscillate))
        }

        self.percent1Node = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"))
        self.percent2Node = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"))
        self.percent1Node!.xScale = 0.75
        self.percent1Node!.yScale = 0.75
        self.percent2Node!.xScale = 0.75
        self.percent2Node!.yScale = 0.75
        self.percent1Node!.position.x = 600
        self.percent1Node!.position.y = -50
        self.percent2Node!.position.x = -600
        self.percent2Node!.position.y = -50
        self.percent1Node!.zPosition = 20
        self.percent2Node!.zPosition = 20
        self.addChild(percent1Node!)
        self.addChild(percent2Node!)

        let ratio:CGFloat = 101.0 / 50.0
        let speed:CGFloat = 100
        let move1 = SKAction.follow(upArrowPath.cgPath, asOffset: true, orientToPath: false, speed: speed * ratio) // 101
        percent1Node!.run(move1, completion: {
            print("up wins")
            let transition = SKTransition.fade(withDuration: 1)
            let winScene = WinScene(fileNamed: "WinScene")
            winScene?.loved = 1
            winScene?.viewController = self.viewController
            winScene?.scaleMode = .aspectFill
            self.view?.presentScene(winScene!, transition: transition)
        })
        percent1Node?.isPaused = true
        let move2 = SKAction.follow(downArrowPath.cgPath, asOffset: true, orientToPath: false, speed: speed) // 50
        percent2Node!.run(move2, completion: {
            print("down wins")
            let transition = SKTransition.fade(withDuration: 1)
            let winScene = WinScene(fileNamed: "WinScene")
            winScene?.loved = 2
            winScene?.viewController = self.viewController
            winScene?.scaleMode = .aspectFill
            self.view?.presentScene(winScene!, transition: transition)
            })
        percent2Node?.isPaused = true

        if SHOW_CAMERA_AND_LANDMARKS > 0 {
            // self.cameraNode = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"), size: CGSize(width: 850, height: 500))
            self.cameraNode = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"), size: CGSize(width: 2000, height: 1300))
            self.cameraNode!.position.x = 0
            self.cameraNode!.position.y = 0
            self.cameraNode!.zPosition = 9
            self.addChild(cameraNode!)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.heart1Node!.alpha = CGFloat(self.viewController.r1_level)
        self.heart2Node!.alpha = CGFloat(self.viewController.r2_level)

//        self.percent1Node?.position.y = CGFloat(self.viewController.r1_percent * 100)
//        self.percent2Node?.position.y = CGFloat(self.viewController.r2_percent * 100)

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
    static func oscillation(amplitudeX ax: CGFloat, amplitudeY ay: CGFloat, timePeriod t: CGFloat, midPoint: CGPoint, offset: CGFloat) -> SKAction {
        let action = SKAction.customAction(withDuration: Double(t)) { node, currentTime in
            let o = (2.0 * CGFloat.pi) * currentTime / t  + offset
            let displacement_x = ax * sin(o)
            let displacement_y = ay * cos(o)
            node.position.x = midPoint.x + displacement_x
            node.position.y = midPoint.y + displacement_y
        }

        return action
    }

}
