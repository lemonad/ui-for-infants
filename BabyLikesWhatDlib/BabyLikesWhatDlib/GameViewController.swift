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

    func captured(image: UIImage, leftPupilOffset: CGPoint, rightPupilOffset: CGPoint) {
        // leftEye.image = wrapper.getEye(image)
        // leftEye.image = image

        like1Window[windowIndex] = Double(scene.like1Node!.position.x)
        like2Window[windowIndex] = Double(scene.like2Node!.position.x)
        // leftEyeWindow[windowIndex] = 0 // Double(initRand.nextUniform())
        // rightEyeWindow[windowIndex] = 0 // Double(initRand.nextUniform())
        leftEyeWindow[windowIndex] = Double(leftPupilOffset.x)
        rightEyeWindow[windowIndex] = Double(rightPupilOffset.x)

        var left: [Double] = []
        var right: [Double] = []
        var like1: [Double] = []
        var like2: [Double] = []

        var index = windowIndex
        var r1_check_level = 0
        var level_reached = false
        var level = 0
        //for level in 0...5 {
            for _ in 1...30 {
                left.append(leftEyeWindow[index])
                right.append(rightEyeWindow[index])
                like1.append(like1Window[index])
                index = (index - 1 + windowSize) % windowSize
            }

            r1_left[level] = CGFloat(CorrelationCoefficient(X: left, Y: like1))
            r1_right[level] = CGFloat(CorrelationCoefficient(X: right, Y: like1))
//            if level_reached {
//                continue
//            }
            let r1_mean = (r1_left[level] + r1_right[level]) / 2.0
            if r1_mean > 0.6 {
                r1_check_level = level + 1
            } else {
                level_reached = true
                //                for rest_level in (level + 1)...5 {
                //                    r1_left[rest_level] = 0.0
                //                    r1_right[rest_level] = 0.0
                //                }
                //                break
            }
        // }
        r1_level = max(r1_mean, 0.0)
        if r1_level >= 0.6 {
            scene.percent1Node?.isPaused = false
        } else {
            scene.percent1Node?.isPaused = true
        }

        left.removeAll()
        right.removeAll()
        index = windowIndex
        var r2_check_level = 0
        level_reached = false
        // for level in 0...5 {
            for _ in 1...30 {
                left.append(leftEyeWindow[index])
                right.append(rightEyeWindow[index])
                like2.append(like2Window[index])
                index = (index - 1 + windowSize) % windowSize
            }

            r2_left[level] = CGFloat(CorrelationCoefficient(X: left, Y: like2))
            r2_right[level] = CGFloat(CorrelationCoefficient(X: right, Y: like2))
//            if level_reached {
//                continue
//            }
            let r2_mean = (r2_left[level] + r2_right[level]) / 2.0
            // print(r2_mean)
            if r2_mean > 0.6 {
                r2_check_level = level + 1
            } else {
                level_reached = true
                //                for rest_level in (level+1)...5 {
                //                    r2_left[rest_level] = 0.0
                //                    r2_right[rest_level] = 0.0
                //                }
                //                break
            }
        // }
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
