//
//  GameScene.swift
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-22.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

//import SpriteKit
//import GameplayKit
//
//class GameScene: SKScene {
//    var viewController: GameViewController!
//
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
//
//    override func didMove(to view: SKView) {
//
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
//
//
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
//}



//
//  GameScene.swift
//  BabyLikesYou
//
//  Created by Jonas on 2017-07-16.
//  Copyright © 2017 Jonas Nockert. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    var viewController: GameViewController!

    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
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

        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)

        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5

            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
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

        self.cameraNode = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"), size: CGSize(width: 850, height: 500))
        // self.cameraNode = SKSpriteNode(texture: SKTexture(imageNamed: "Heart"), size: CGSize(width: 2000, height: 1300))
        self.cameraNode!.position.x = 0
        self.cameraNode!.position.y = 0
        self.cameraNode!.zPosition = 9
        // self.addChild(cameraNode!)

        self.faceRectNode = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 100, height: 100))
        self.faceRectNode!.position.x = -600
        self.faceRectNode!.position.y = 0
        self.faceRectNode!.zPosition = 20
        self.faceRectNode!.alpha = 0.3
        // self.addChild(faceRectNode!)
    }


    func touchDown(atPoint pos: CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }

    func touchMoved(toPoint pos: CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }

    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }

        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.heart1Node!.alpha = CGFloat(self.viewController.r1_level) / 6.0
        self.heart2Node!.alpha = CGFloat(self.viewController.r2_level) / 6.0

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

        //        r1LeftLabel.text = String(format: "%.2f", viewController.r1_left)
        //        r1RightLabel.text = String(format: "%.2f", viewController.r1_right)
        //        r2LeftLabel.text = String(format: "%.2f", viewController.r2_left)
        //        r2RightLabel.text = String(format: "%.2f", viewController.r2_right)
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
