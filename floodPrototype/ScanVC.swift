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
    
    let validReceiptIDs = ["1ga3t15z", "5f1t3t13", "35h35h24h24ht"]
    
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var bracketView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        highlightView.autoresizingMask = [.FlexibleTopMargin, .FlexibleBottomMargin, .FlexibleLeftMargin, .FlexibleRightMargin]
        
        // Scan reticle's border
        highlightView.layer.borderColor = UIColor.greenColor().CGColor
        highlightView.layer.borderWidth = 3
        
        bracketView.addSubview(highlightView)
        
        let standardBlue = UIColor(colorLiteralRed: 74/255,
            green: 135/255, blue: 238/255, alpha: 1)
        instructions.backgroundColor = standardBlue
        view.backgroundColor = standardBlue
        view.tintColor = UIColor.whiteColor()
        
        do{
            input =  try AVCaptureDeviceInput(device: device)
            session.addInput(input)
            output = AVCaptureMetadataOutput()
            output?.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            session.addOutput(output)
            output?.metadataObjectTypes = output?.availableMetadataObjectTypes
            
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.frame = previewView.bounds
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewView.layer.addSublayer(previewLayer!)
            
            instructions.text = "Center the camera on your receipt"
            instructions.sizeToFit()
            previewView.bringSubviewToFront(instructions)
            view.bringSubviewToFront(bracketView)
            
            session.startRunning()
            
            
        } catch {
            instructions.text = "Camera could not start. Please enable access to the camera in the iOS Settings"
        }
        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
        navigationController?.toolbarHidden = true
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
        previewLayer?.frame = previewView.bounds
        bracketView.setNeedsDisplay()
        
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
        //print(detectionString);
        highlightView.frame = highlightViewRect
        
        capturedQRCode(detectionString);
        //view.bringSubviewToFront(self.highlightView)
        
    }
    
    func resumeScanning(){
        session.startRunning()
        highlightView.frame = CGRectZero
    }
    
    func capturedQRCode(codeString:String?){
        //print(codeString)
        guard let codeData = codeString?.dataUsingEncoding(NSUTF8StringEncoding) else {
            resumeScanning()
            return
        }
        do{
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(codeData, options: NSJSONReadingOptions.MutableContainers)
            if let jsonDictionary = jsonResult as? [String:AnyObject],
                let id = jsonDictionary["id"] as? String,
                let showReceiptController = storyboard?.instantiateViewControllerWithIdentifier("showReceiptTVC") as? showReceiptTVC
                where validReceiptIDs.contains(id) {
                    NSUserDefaults.standardUserDefaults().setObject(jsonDictionary, forKey: "lastReceipt")
                    showReceiptController.receiptDict = jsonDictionary
                    navigationController?.pushViewController(showReceiptController, animated: true)
            
            }else{
                resumeScanning()
            }
        } catch _ as NSError { resumeScanning() }
    }
}
