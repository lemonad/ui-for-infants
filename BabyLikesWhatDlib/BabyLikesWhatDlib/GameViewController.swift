//
//  GameViewController.swift
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-22.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


let windowSize = 60  // Need to change ranges too.

class GameViewController: UIViewController, CameraHandlerDelegate {
    var cameraHandler: CameraHandler!
    var scene: GameScene!

    private var windowIndex = 0
    private var leftEyeWindow: [Double] = []
    private var rightEyeWindow: [Double] = []
    private var like1Window: [Double] = []
    private var like2Window: [Double] = []
    var r1_left: [CGFloat] = Array(repeating: 0.0, count: 6)
    var r2_left: [CGFloat] = Array(repeating: 0.0, count: 6)
    var r1_right: [CGFloat] = Array(repeating: 0.0, count: 6)
    var r2_right: [CGFloat] = Array(repeating: 0.0, count: 6)
    var r1_level:CGFloat = 0.0
    var r2_level:CGFloat = 0.0
    let initRand = GKRandomDistribution(lowestValue: -100, highestValue: 100)

    var r1_percent = 0.0;
    var r2_percent = 0.0;

    var faceRect: CGRect?
    var leftEyeRect: CGRect?
    var leftEyePupilPoint: CGPoint?
    var rightEyeRect: CGRect?
    var rightEyePupilPoint: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'

            /* Make sure we don't start with a correlation. */
            for _ in 0..<windowSize {
                leftEyeWindow.append(Double(initRand.nextUniform()))
                rightEyeWindow.append(Double(initRand.nextUniform()))
                like1Window.append(Double(initRand.nextUniform()))
                like2Window.append(Double(initRand.nextUniform()))
            }

            scene = GameScene(fileNamed: "GameScene")
            scene.viewController = self
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill

            // Present the scene
            view.presentScene(scene)

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true

            cameraHandler = CameraHandler()
            cameraHandler.delegate = self
        }
    }

    func noEyeCaptured() {
        scene.eyeLabel?.alpha = 0
    }

    func eyeCaptured(image: UIImage, leftPupilOffset: CGPoint, rightPupilOffset: CGPoint) {
        scene.eyeLabel?.alpha = 0.3

        like1Window[windowIndex] = Double(scene.like1Node!.position.x)
        like2Window[windowIndex] = Double(scene.like2Node!.position.x)
        leftEyeWindow[windowIndex] = Double(leftPupilOffset.x)
        rightEyeWindow[windowIndex] = Double(rightPupilOffset.x)

        var left: [Double] = []
        var right: [Double] = []
        var like1: [Double] = []
        var like2: [Double] = []

        var index = windowIndex
        for _ in 1...30 {
            left.append(leftEyeWindow[index])
            right.append(rightEyeWindow[index])
            like1.append(like1Window[index])
            like2.append(like2Window[index])
            index = (index - 1 + windowSize) % windowSize
        }

        r1_left[0] = CGFloat(CorrelationCoefficient(X: left, Y: like1))
        r1_right[0] = CGFloat(CorrelationCoefficient(X: right, Y: like1))
        let r1_mean = (r1_left[0] + r1_right[0]) / 2.0

        r1_level = max(r1_mean, 0.0)
        if r1_level >= 0.6 {
            scene.percent1Node?.isPaused = false
        } else {
            scene.percent1Node?.isPaused = true
        }

        index = windowIndex

        r2_left[0] = CGFloat(CorrelationCoefficient(X: left, Y: like2))
        r2_right[0] = CGFloat(CorrelationCoefficient(X: right, Y: like2))
        let r2_mean = (r2_left[0] + r2_right[0]) / 2.0

        r2_level = max(r2_mean, 0.0)
        if r2_level >= 0.6 {
            scene.percent2Node?.isPaused = false
        } else {
            scene.percent2Node?.isPaused = true
        }

        windowIndex = (windowIndex + 1) % windowSize

        if SHOW_CAMERA_AND_LANDMARKS > 0 {
            let tex = SKTexture(image: image)
            DispatchQueue.main.async {
                self.scene.cameraNode!.texture = tex
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
