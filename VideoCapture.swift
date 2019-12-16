//
//  VideoCapture.swift
//  ProjectMC2
//
//  Created by Randy Noel on 08/07/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import AVFoundation
import UIKit
import CoreVideo

public protocol VideoCaptureDelegate: class {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame: CVPixelBuffer?, timedtamp:CMTime)
}

public class VideoCapture: NSObject {
    public var previewLayer: AVCaptureVideoPreviewLayer?
    public weak var delegate: VideoCaptureDelegate?
    public var fps = 1
    
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    let queue = DispatchQueue(label: "com.whiteHat98.camera-queue")
    
    var lastTimeStamp = CMTime()
    
    public func setUp(sessionPreset: AVCaptureSession.Preset = .hd1280x720, completion: @escaping (Bool) -> Void){
        setUpCamera(sessionPreset: sessionPreset, completion: {success in completion(success)})
    }
    
    func setUpCamera(sessionPreset: AVCaptureSession.Preset, completion: @escaping (_ success:Bool) -> Void){
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = sessionPreset
        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        
        print("pass")
        
        guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice!), captureSession.canAddInput(videoInput) else {
            print("error: ccould not create AVCaptureDeviceInput")
            return
        }
        
        print("wakaka!")
        
        //if captureSession.canAddInput(videoInput){
        captureSession.addInput(videoInput)
        
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        self.previewLayer = previewLayer
        
        let settings: [String : Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA),
        ]
        
        videoOutput.videoSettings = settings
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        if captureSession.canAddOutput(videoOutput){
            captureSession.addOutput(videoOutput)
        }
        
        videoOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
        
        captureSession.commitConfiguration()
        
        let success = true
        completion(success)
        
    }
    
    public func start(){
        if !captureSession.isRunning{
            captureSession.startRunning()
        }
    }
    
    public func stop(){
        if captureSession.isRunning{
            captureSession.stopRunning()
        }
    }
}

extension VideoCapture : AVCaptureVideoDataOutputSampleBufferDelegate{
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let deltaTime = timestamp - lastTimeStamp
        if deltaTime >=  CMTimeMake(value: 1, timescale: Int32(fps)){
            lastTimeStamp = timestamp
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            delegate?.videoCapture(self, didCaptureVideoFrame: imageBuffer, timedtamp: timestamp)
        }
    }
    
}

