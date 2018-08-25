//
//  CameraHandler.swift
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-23.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

import AVFoundation
import UIKit

protocol CameraHandlerDelegate: class {
    func noEyeCaptured()
    func eyeCaptured(image: UIImage, leftPupilOffset: CGPoint, rightPupilOffset: CGPoint)
}

class CameraHandler: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate {
    var session = AVCaptureSession()
    weak var delegate: CameraHandlerDelegate?
    private var permissionGranted = false
    private let sampleQueue = DispatchQueue(label: "sample queue")
    private let faceQueue = DispatchQueue(label: "face queue")
    private let context = CIContext()
    private let dlib_wrapper = DlibWrapper()
    private var videoDevicePosition: AVCaptureDevice.Position = .front

    private var currentMetadata: [AnyObject]

    override init() {
        currentMetadata = []
        super.init()
        checkPermission()
        sampleQueue.async { [unowned self] in
            if self.openSession() {
                self.dlib_wrapper?.prepare()
                self.session.startRunning()
            }
        }
    }

    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }

    private func requestPermission() {
        self.sampleQueue.suspend()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sampleQueue.resume()
        }
    }

    func openSession() -> Bool {
        guard permissionGranted else { return false }

        session.sessionPreset = AVCaptureSession.Preset.high;

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else {
            print("Error: Can't get front camera capture device.")
            return false
        }
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            print("Error: Can't get input capture device.")
            return false
        }
        if !session.canAddInput(input) {
            print("Error: Can't add session input.")
            return false
        }
        let output = AVCaptureVideoDataOutput()
        if !session.canAddOutput(output) {
            print("Error: Can't add session output.")
            return false
        }
        let metaOutput = AVCaptureMetadataOutput()
        metaOutput.setMetadataObjectsDelegate(self, queue: faceQueue)
        if !session.canAddOutput(metaOutput) {
            print("Error: Can't add metadata output.")
            return false
        }

        session.beginConfiguration()
        session.addOutput(output)
        session.addInput(input)
        session.addOutput(metaOutput)
        session.commitConfiguration()

        // kCVPixelFormatType_32BGRA
        let settings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        output.videoSettings = settings as! [String : Any]
        output.setSampleBufferDelegate(self, queue: sampleQueue)
        output.alwaysDiscardsLateVideoFrames = true

        guard let connection = output.connection(with: AVFoundation.AVMediaType.video)
            else { return false }
        guard connection.isVideoOrientationSupported else { return false }
        guard connection.isVideoMirroringSupported else { return false }
        connection.videoOrientation = .landscapeRight
        connection.isVideoMirrored = true

        // availableMetadataObjectTypes change when output is added to session.
        // before it is added, availableMetadataObjectTypes is empty
        metaOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.face]

        return true
    }

    private func uiImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    func exifOrientationFromDeviceOrientation() -> Int32 {
        enum DeviceOrientation: Int32 {
            case top0ColLeft = 1
            case top0ColRight = 2
            case bottom0ColRight = 3
            case bottom0ColLeft = 4
            case left0ColTop = 5
            case right0ColTop = 6
            case right0ColBottom = 7
            case left0ColBottom = 8
        }
        var exifOrientation: DeviceOrientation

        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            exifOrientation = .left0ColBottom
        case .landscapeLeft:
            exifOrientation = videoDevicePosition == .front ? .bottom0ColRight : .top0ColLeft
        case .landscapeRight:
            exifOrientation = videoDevicePosition == .front ? .top0ColLeft : .bottom0ColRight
        default:
            exifOrientation = .right0ColTop
        }
        return exifOrientation.rawValue
    }

    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        if currentMetadata.isEmpty {
            self.delegate?.noEyeCaptured()
        } else {
            // GameScene.eyeLabel.alpha = 1
            let boundsArray = currentMetadata
                .compactMap { $0 as? AVMetadataFaceObject }
                .map { (faceObject) -> NSValue in
                    let convertedObject = output.transformedMetadataObject(for: faceObject, connection: connection)
                    return NSValue(cgRect: convertedObject!.bounds)
            }

            var pupilOffsets = dlib_wrapper?.doWork(on: sampleBuffer, inRects: boundsArray)
            if (pupilOffsets?.count)! < 2 {
                self.delegate?.noEyeCaptured()
                return
            }
            // guard let uiImage = uiImageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }

            // let exifOrientation = self.exifOrientationFromDeviceOrientation()
            // let cameraImage = CIImage(cvImageBuffer: sampleBuffer as! CVImageBuffer).oriented(forExifOrientation: exifOrientation)

            DispatchQueue.main.async { [unowned self] in
                if SHOW_CAMERA_AND_LANDMARKS > 0 {
                    let uiImage = self.uiImageFromSampleBuffer(sampleBuffer: sampleBuffer)
                    self.delegate?.eyeCaptured(image: uiImage!,
                                               leftPupilOffset: pupilOffsets?[0] as! CGPoint,
                                               rightPupilOffset: pupilOffsets?[1] as! CGPoint)
                } else {
                    self.delegate?.eyeCaptured(image: UIImage(),
                                               leftPupilOffset: pupilOffsets?[0] as! CGPoint,
                                               rightPupilOffset: pupilOffsets?[1] as! CGPoint)
                }
            }
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let seconds = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        print("Dropped sample buffer: \(seconds)")
    }

    // MARK: AVCaptureMetadataOutputObjectsDelegate

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        currentMetadata = metadataObjects as [AnyObject]
    }
}
