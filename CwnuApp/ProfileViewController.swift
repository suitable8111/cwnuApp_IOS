//
//  ProfileViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 9..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit
//import Google

class ProfileViewController : UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    @IBOutlet var barcodeImageView: UIImageView!
    @IBOutlet var thumbNailImage: UIImageView!
    @IBOutlet var realNameLabel: UILabel!
    @IBOutlet var schooNumLabel: UILabel!
    //@IBOutlet var titleLabel: UILabel!
    //@IBOutlet var updateConfirmBtn: UIButton!
    //@IBOutlet var barcodeView: UIView!
    //@IBOutlet var updaterealNameTF: UITextField!
    @IBOutlet var updateBtnLabel: UILabel!
    //@IBOutlet var barcodeNumLabel: UILabel!
    
    var user : KOUser?
    var isUpdate : Bool = false
    private func requestMe(displayResult: Bool = false) {
        
        KOSessionTask.meTaskWithCompletionHandler { [weak self] (user, error) -> Void in
            if error != nil {
                
            } else {
                self?.user = (user as! KOUser)
                
                self!.thumbNailImage.layer.cornerRadius = 50
                self!.thumbNailImage.layer.masksToBounds = true
                if ((user.properties[CwnuTag.KAKAO_THUMBPATH] as? String) != ""){
                    self!.thumbNailImage.downloadedFrom(link: user.properties[CwnuTag.KAKAO_THUMBPATH] as! String, contentMode: UIViewContentMode.ScaleToFill)
                }else {
                    self!.thumbNailImage.image = UIImage(named: "profile_default_image.png")
                }
                if ((user.properties[CwnuTag.KAKAO_REALNAME] as? String) != ""){
                    self!.realNameLabel.text = user.properties[CwnuTag.KAKAO_REALNAME] as? String
                }
                if ((user.properties[CwnuTag.KAKAO_SCHOOLNUM] as? String) != nil){
                    self!.schooNumLabel.text = user.properties[CwnuTag.KAKAO_SCHOOLNUM] as? String
                    self!.barcodeImageView.image = self!.generateBarcodeFromString((self!.user!.properties[CwnuTag.KAKAO_SCHOOLNUM] as? String)!)
                }
            }
        }
        
    }
    private func updateMe(displayResult: Bool = false) {
        
        KOSessionTask.profileUpdateTaskWithProperties(getFormData(), completionHandler: { (success, error) -> Void in
            if error != nil {
                
            } else {
                
            }
            })
    }
    
    private func getFormData() -> [NSObject:AnyObject] {
        var formData = [String:String]()
        
        formData[CwnuTag.KAKAO_THUMBPATH] = "http://cinavro12.cafe24.com/cwnu/user/profile/uploads/"+(self.user!.ID.stringValue)+".png"
        
        return formData
    }
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "(아이폰)프로필화면")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestMe()
        //self.barcodeView.hidden = true
        //self.updateConfirmBtn.hidden = true
        //self.updaterealNameTF.hidden = true
        
    }
    
    @IBAction func actBarCodePopUp(sender: AnyObject) {
        
        if ((self.user!.properties[CwnuTag.KAKAO_SCHOOLNUM] as? String) == nil){
            //바코드 인증하기
            let alert = UIAlertController(title: "바코드인증", message:"학생증으로 바코드르 인증하시겠습니까?", preferredStyle: .Alert)
            let action = UIAlertAction(title: "인증하기", style: .Default) { _ in
                // Put here any code that you would like to execute when
                // the user taps that OK button (may be empty in your case if that's just
                // an informative alert)
                let cbControl = self.storyboard?.instantiateViewControllerWithIdentifier("CaptureBarcodeViewController") as! CaptureBarcodeViewController
                
                self.navigationController?.pushViewController(cbControl, animated: true)
            }
            let cancel = UIAlertAction(title: "취소", style: .Cancel, handler: { _ in
                
            })
            alert.addAction(action)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true){}
        }else {
            let alert = UIAlertController(title: "기존의 학생증를 바꾸시겠습니까?", message:"타인의 바코드를 사용할 경우 법적 처분을 받을 수 있습니다", preferredStyle: .Alert)
            let action = UIAlertAction(title: "인증하기", style: .Default) { _ in
                // Put here any code that you would like to execute when
                // the user taps that OK button (may be empty in your case if that's just
                // an informative alert)
                let cbControl = self.storyboard?.instantiateViewControllerWithIdentifier("CaptureBarcodeViewController") as! CaptureBarcodeViewController
                
                self.navigationController?.pushViewController(cbControl, animated: true)
            }
            let cancel = UIAlertAction(title: "취소", style: .Cancel, handler: { _ in
                
            })
            alert.addAction(action)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true){}
            //바코드 보여주기
//            if barcodeView.hidden == true {
//                self.barcodeView.hidden = false
//                self.barcodeImageView.image = generateBarcodeFromString((self.user!.properties[CwnuTag.KAKAO_SCHOOLNUM] as? String)!)
//            }else {
//                self.barcodeView.hidden = true
//            }
        }
    }
    func generateBarcodeFromString(string: String) -> UIImage? {
        let data = string.dataUsingEncoding(NSASCIIStringEncoding)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransformMakeScale(3, 3)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                //barcodeNumLabel.text = string
                return UIImage(CIImage: output)
            }
        }
        
        return nil
    }
    
//    private func appearObj()  {
//        //로컬 변환
//        //self.updaterealNameTF.hidden = true
//        //self.updateConfirmBtn.hidden = true
//        self.realNameLabel.hidden = false
//        
//        //self.realNameLabel.text = self.updaterealNameTF.text
//        self.updateBtnLabel.text = "업데이트"
//        //self.titleLabel.text = "프로필"
//        
//        //서버 변환
//        self.updateMe()
//        isUpdate = false
//    }
//    @IBAction func actUpdateUser(sender: AnyObject) {
//        if !isUpdate {
//            self.updaterealNameTF.hidden = false
//            self.realNameLabel.hidden = true
//            //self.updateConfirmBtn.hidden = false
//            self.updaterealNameTF.text = self.realNameLabel.text
//            self.updateBtnLabel.text = "확인"
//            //self.titleLabel.text = "업데이트"
//            
//            UIView.animateWithDuration(0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
//                self.updaterealNameTF.transform = CGAffineTransformMakeTranslation(0, -200);
//                self.thumbNailImage.transform = CGAffineTransformMakeTranslation(0, -200);
//                }, completion: nil)
//            isUpdate = true
//        }else {
//            //로컬 번경
//            
//            UIView.animateWithDuration(0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
//                self.updaterealNameTF.transform = CGAffineTransformMakeTranslation(0, 0);
//                self.thumbNailImage.transform = CGAffineTransformMakeTranslation(0, 0);
//                }, completion: {finished in self.appearObj()})
//        }
//    }
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func actLogout(sender: AnyObject) {
        KOSession.sharedSession().logoutAndCloseWithCompletionHandler { [weak self] (success, error) -> Void in
                        self?.navigationController?.popViewControllerAnimated(true)
                    }
    }
    @IBAction func actPhotoUpdate(sender: AnyObject) {
//        let cbControl = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoUpdateViewController") as! PhotoUpdateViewController
//        self.navigationController?.pushViewController(cbControl, animated: true)
        
        let alert = UIAlertController(title: "사진가져오기", message: "선택하시오.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        let action1 = UIAlertAction(title: "취소", style: UIAlertActionStyle.Cancel, handler: nil)
        let action2 = UIAlertAction(title: "사진찍기", style: UIAlertActionStyle.Default, handler: action2Handler)
        let action3 = UIAlertAction(title: "앨범에서 가져오기", style: UIAlertActionStyle.Default, handler: action3Handler)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func action2Handler(alert:UIAlertAction?){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func action3Handler(alert:UIAlertAction?){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //로컬변환
        self.thumbNailImage.image = image
        //서버변환
        self.uploadToServer()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func uploadToServer() {
        let myUrl = NSURL(string: "http://cinavro12.cafe24.com/cwnu/user/profile/upload_server_image.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST";
//        let param = [
//            "firstName"  : "Sergey",
//            "lastName"    : "Kargopolov",
//            "userId"    : "9"
//        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //이미지 데이터
        //let imageData = UIImageJPEGRepresentation(self.thumbNailImage.image!,1)
        let imageData = resizeImage(self.thumbNailImage.image!)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(imageData!, boundary: boundary)
        
        
        
        //myActivityIndicator.startAnimating();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            
            //var err: NSError?
            //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
            
            
            dispatch_async(dispatch_get_main_queue(),{
                //self.myActivityIndicator.stopAnimating()
                //self.myImageView.image = nil;
                self.updateMe()
            });
            
            /*
             if let parseJSON = json {
             var firstNameValue = parseJSON["firstName"] as? String
             println("firstNameValue: \(firstNameValue)")
             }
             */
            
        }
        
        task.resume()
    }
    func createBodyWithParameters(imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
//        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString("--\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//        }
//        
        let filename = (self.user!.ID.stringValue)+".png"
//        
        let mimetype = "image/png"
//
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"uploaded_file\";filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
//        
//
//        
        body.appendString("--\(boundary)--\r\n")
//        
        return body
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
//    @IBAction func actExit(sender: AnyObject) {
//        
//        let request : NSMutableURLRequest? = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/user/cwnu_delete_user_info.php")!)
//        
//        request!.HTTPMethod = "POST"
//        var kakaoid = ""
//        if (self.user?.ID != nil) {
//            kakaoid = String(self.user!.ID!)
//        }else {
//            kakaoid = "error!"
//        }
//        let postString = "kakaoid="+kakaoid
//        
//        request!.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request!)  { data, response, error in
//            guard error == nil && data != nil else {                                                          // check for fundamental networking error
//                print("error=\(error)")
//                return
//            }
//            
//            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print("responseString = \(responseString)")
//
//        }
//        task.resume()
//        KOSessionTask.unlinkTaskWithCompletionHandler { [weak self] (success, error) -> Void in
//            
//            self?.navigationController?.popViewControllerAnimated(true)
//        }
//    }
    func resizeImage(image : UIImage) -> NSData? {
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 400.0
        let maxWidth : CGFloat = 300.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        //let compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.drawInRect(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImagePNGRepresentation(img)
        UIGraphicsEndImageContext()
        return imageData
        
    }
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}