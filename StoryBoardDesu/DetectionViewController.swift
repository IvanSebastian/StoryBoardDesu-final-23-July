//
//  ViewController.swift
//  ShowTime
//
//  Created by Randy Noel on 09/07/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import UIKit
import Vision
import CoreMedia
//note: kalau buat Container View dan buat ViewCOntainer baru pengiriman informasi tetap bisa jalan tetapi dia kirim nya ke view container. jadi tidak muncul di main view controller.
class DetectionViewController: UIViewController {
    public typealias DetectObjectsCompletion = ([PredictedPoint?]?, Error?) -> Void
    

    
    @IBOutlet weak var jointCamera: UIView!
    
    @IBOutlet weak var jointView: DrawingJoint!
    
    @IBOutlet weak var containerView: UIView!
    //    let targetVC = TargetPointViewController()
    var targetVC : TargetPointViewController!
    
    private let measure = Measure()
    
    var videoCapture = VideoCapture()
    
    typealias EstimateModel = model_cpm
    
    var request: VNCoreMLRequest?
    var visionModel: VNCoreMLModel?
    
    var postProcessor: HeatmapPostProcessor = HeatmapPostProcessor()
    var mvfilters: [MovingAverageFilter] = []
    
    private var tableData: [PredictedPoint?] = []
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpModel()
        print("record!")
        setUpCamera()
        //targetCatch(target: target)
        // measure.delegate = self
        
//        containerView.view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            targetVC = segue.destination as! TargetPointViewController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    
    //var joints:[UIView]!
    //detect target position
    

    
    
    
    //setUpModel
    func setUpModel(){
        if let visionModel = try? VNCoreMLModel(for: EstimateModel().model){
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .scaleFill
        } else{
            fatalError()
        }
    }
    
    //setup video
    func setUpCamera(){
        videoCapture = VideoCapture()
        
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .hd1280x720) { success in
            if success {
                
                //add preview view on the layer
                if let previewLayer = self.videoCapture.previewLayer{
                    self.jointCamera.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                    
                }
                
                self.videoCapture.start()
                //print("record!")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer(){
        videoCapture.previewLayer?.frame = jointCamera.bounds
    }
    
}

extension DetectionViewController: VideoCaptureDelegate{
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timedtamp: CMTime) {
        if let pixelBuffer = pixelBuffer{
            //start measure
            self.measure.recordStart()
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
}


extension DetectionViewController {
    
    func predictUsingVision(pixelBuffer : CVPixelBuffer){
        guard let request = request else {fatalError()}
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?){
        self.measure.tag(with: "endInference")
        if let observations = request.results as? [VNCoreMLFeatureValueObservation], let heatmaps = observations.first?.featureValue.multiArrayValue {
            
            //post-processing
            //convert heatmap to point array
            var predictedPoints = postProcessor.convertToPredictedPoints(from: heatmaps, isInverse: true)
            
            //moving average filter
            if predictedPoints.count != mvfilters.count{
                mvfilters = predictedPoints.map{ _ in MovingAverageFilter(limit: 3)}
            }
            for (predictedPoint, filter) in zip(predictedPoints, mvfilters){
                filter.add(element: predictedPoint)
            }
            predictedPoints = mvfilters.map {$0.averagedValue()}
            
            //display the result
            DispatchQueue.main.sync {
                //draw line
                self.jointView.bodyPoints = predictedPoints
                
                targetVC.isHandOnTarget(jointView: jointView)
               
                //show key points description
                self.showKeyPointsDesc(with: predictedPoints)
                
                //end measure
                self.measure.recordStop()
            }
        }else{
            self.measure.recordStop()
        }
    }
    
    func showKeyPointsDesc(with n_kpoints: [PredictedPoint?]){
        self.tableData = n_kpoints
    }
}

//extension ViewController: MeasureDelegate{
//
//}


