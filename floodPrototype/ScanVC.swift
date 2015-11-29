//
//  ScanVC.swift
//  floodPrototype
//
//  Created by Mark Xue on 11/28/15.
//  Copyright © 2015 Mark Xue. All rights reserved.
//

import UIKit
import AVFoundation

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var session:AVCaptureSession = AVCaptureSession()
    var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var input:AVCaptureDeviceInput?
    var output:AVCaptureMetadataOutput?
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    var highlightView = UIView()
    
    @IBOutlet weak var instructions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highlightView.autoresizingMask = [.FlexibleTopMargin, .FlexibleBottomMargin, .FlexibleLeftMargin, .FlexibleRightMargin]
        
        // Scan reticle's border
        highlightView.layer.borderColor = UIColor.greenColor().CGColor
        highlightView.layer.borderWidth = 3
        
        view.addSubview(highlightView)
        
        do{
            input =  try AVCaptureDeviceInput(device: device)
            session.addInput(input)
            output = AVCaptureMetadataOutput()
            output?.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            session.addOutput(output)
            output?.metadataObjectTypes = output?.availableMetadataObjectTypes
            
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.frame = view.bounds
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            view.layer.addSublayer(previewLayer!)
            
            instructions.text = "Scan a QR code from your receipt to learn more about your water consumption"
            instructions.sizeToFit()
            view.bringSubviewToFront(instructions)
            
            session.startRunning()
            
            
        } catch {
            instructions.text = "Camera could not start. Please enable access to the camera in the iOS Settings"
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        highlightView.frame = CGRectZero
        session.startRunning()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func videoOrientationFromInterfaceOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch (orientation) {
        case .LandscapeLeft:
            return .LandscapeLeft
        case .LandscapeRight:
            return .LandscapeRight
        case .Portrait:
            return .Portrait
        default:
            return .PortraitUpsideDown
        }
    }
    
    func orientationChanged(notification:NSNotification){
        previewLayer?.frame = view.bounds
        
        if previewLayer?.connection != nil {
            let orientation = UIApplication.sharedApplication().statusBarOrientation
            
            previewLayer?.connection.videoOrientation = videoOrientationFromInterfaceOrientation(orientation)
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var highlightViewRect = CGRectZero
        var barcodeObject : AVMetadataObject?
        var detectionString : String?
        
        for metaData in metadataObjects{
            if metaData.type == AVMetadataObjectTypeQRCode {
                barcodeObject = previewLayer?.transformedMetadataObjectForMetadataObject(metaData as! AVMetadataMachineReadableCodeObject)
                highlightViewRect = (barcodeObject?.bounds)!
                detectionString = (metaData).stringValue
                session.stopRunning()
                break
            }
        }
        print(detectionString);
        highlightView.frame = highlightViewRect
        view.bringSubviewToFront(self.highlightView)
        
    }

}
