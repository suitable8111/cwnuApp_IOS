//
//  CaptureBarcodeViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 16..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureBarcodeViewController : UIViewController , AVCaptureMetadataOutputObjectsDelegate{
    
//    @IBOutlet var scannedBarcode: UITextView!
    @IBOutlet var cameraPreviceView: UIView!
    let captureSession = AVCaptureSession()
    var captureLayer: AVCaptureVideoPreviewLayer?
//    var identifiedBorder : DiscoveredBarCodeView?
    var user : KOUser?
    var schoolNum : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupScanningSession()
    }
    
    // Local method to setup camera scanning session.
    func setupScanningSession() {
        // Set camera capture device to default.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input: AnyObject = try AVCaptureDeviceInput(device: captureDevice)
            self.captureSession.addInput(input as! AVCaptureInput)
        } catch _ {
            print("error")
        }
        
        let output = AVCaptureMetadataOutput()
        // Set recognisable barcode types as all available barcodes.
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        self.captureSession.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        print(output.availableMetadataObjectTypes)
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        self.captureSession.startRunning()
        
        addPreviewLayer()
        
//        self.identifiedBorder = DiscoveredBarCodeView(frame: self.view.bounds)
//        self.identifiedBorder?.backgroundColor = UIColor.clearColor()
//        self.identifiedBorder?.hidden = true
//        self.view.addSubview(identifiedBorder!)

    }
    
    func addPreviewLayer() {
            
        self.captureLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.captureLayer?.frame = self.cameraPreviceView.frame
        //self.captureLayer?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.captureLayer?.videoGravity = AVLayerVideoGravityResize
        
        self.captureLayer!.position = CGPointMake(CGRectGetMidX(self.cameraPreviceView.bounds), CGRectGetMidY(self.cameraPreviceView.bounds))
        self.cameraPreviceView.layer.addSublayer(self.captureLayer!)
            
    }
    // AVCaptureMetadataOutputObjectsDelegate method
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // Do your action on barcode capture here:
        var capturedBarcode: String?
        
        // Speify the barcodes you want to read
        let supportedBarcodeTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                                     AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                                     AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
        
        // In all scanned values..
        for barcodeMetadata in metadataObjects {
            // ..check if it is a suported barcode
            for supportedBarcode in supportedBarcodeTypes {
                
                if supportedBarcode == barcodeMetadata.type {
                
                    let barcodeObject = self.captureLayer!.transformedMetadataObjectForMetadataObject(barcodeMetadata as! AVMetadataObject)
                    capturedBarcode = (barcodeObject as! AVMetadataMachineReadableCodeObject).stringValue
                    
                    print(capturedBarcode)
                    if capturedBarcode != nil {
                        self.captureSession.stopRunning()
                        
//                        self.identifiedBorder?.frame = barcodeObject.bounds
//                        self.identifiedBorder?.hidden = false

                        
                        print(capturedBarcode)
                        let alert = UIAlertController(title: "바코드를 찾았습니다", message: capturedBarcode!+"\n이 바코드가 맞습니까?", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "맞아요", style: .Default) { _ in
                            //서버 전송
                            self.schoolNum = capturedBarcode!
                            self.requestMe()
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                        let cancel = UIAlertAction(title: "아니에요", style: .Cancel, handler: { _ in
                            self.captureSession.startRunning()
                        })
                        alert.addAction(action)
                        alert.addAction(cancel)
                        self.presentViewController(alert, animated: true){}
                        
                    }
                    // Got the barcode. Set the text in the UI and break out of the loop.
                    
//                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
//                        self.captureSession.stopRunning()
//                        self.scannedBarcode.text = capturedBarcode
//                        
//                    })
                    return
                }
            }
        }
    }
    
    func translatePoints(points : [AnyObject], fromView : UIView, toView: UIView) -> [CGPoint] {
        var translatedPoints : [CGPoint] = []
        for point in points {
        let dict = point as! NSDictionary
        let x = CGFloat((dict.objectForKey("X") as! NSNumber).floatValue)
        let y = CGFloat((dict.objectForKey("Y") as! NSNumber).floatValue)
        let curr = CGPointMake(x, y)
        let currFinal = fromView.convertPoint(curr, toView: toView)
        translatedPoints.append(currFinal)
        }
        return translatedPoints
    }
    private func requestMe(displayResult: Bool = false) {
        
        KOSessionTask.meTaskWithCompletionHandler { [weak self] (user, error) -> Void in
            if error != nil {
                
            } else {
                self?.user = (user as! KOUser)
                self!.updateMe()
            }
        }
        
    }

    
    private func updateMe(displayResult: Bool = false) {
        
        KOSessionTask.profileUpdateTaskWithProperties(getFormData(), completionHandler: {(success, error) -> Void in
            if error != nil {
                
            } else {
                
            }
            })
    }
    
    private func getFormData() -> [NSObject:AnyObject] {
        var formData = [String:String]()
        
        formData[CwnuTag.KAKAO_SCHOOLNUM] = self.schoolNum
        
        return formData
    }

    
    @IBAction func actBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

}