//
//  CertificationViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 15..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit


//사용자 인증관련 ViewController 시나브로 서버에 등록되어 있지않으면 해당 View를 보여준다
//또한 사용자의 카카오 유저를 수집 하는데, 없는 경우 기본값으로 바꾼다.(창대생, 기본 url)
//카카오 로그인을 하고 첫 인증절차만 거친후 그 후는 인증을 거치지 않고 시작한다.
//nickname = 원래 카카오 유저, nick 서버에서 사용할 이름

class CertificationViewController : UIViewController,UITextFieldDelegate {
    
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var agreeWebView: UIWebView!
    @IBOutlet var agreeView: UIView!
    @IBOutlet var hiddenView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    
    //KOUser
    private var user : KOUser?
    
    // MARK -- viewDidLoad
    override func viewDidLoad() {
        self.nameTF.delegate = self
        self.phoneTF.delegate = self
        
        self.cancelBtn.hidden = true
        super.viewDidLoad()
        self.showWebView()
    }
    override func viewWillAppear(animated: Bool) {
        //우선 ViewController에 사용자 정보를 가져온다.
        self.requestMe()
    }
    
    //TEXTFIELD DELGAGET
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(1.0, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransformMakeTranslation(0, -200);
            }, completion: nil)
        self.cancelBtn.hidden = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK - KakaoRequest
    private func requestMe(displayResult: Bool = false) {
        
        KOSessionTask.meTaskWithCompletionHandler { [weak self] (user, error) -> Void in
            if error != nil {
                
            } else {
                self?.user = (user as! KOUser)
                //사용자 정보를 받아온 후, 시나브로 서버에 사용자가 등록되어있는지(전화번호, 이름) 체크한다.
                self!.checkCert()
            }
        }
        
    }
    func updateKakao()  {
        KOSessionTask.profileUpdateTaskWithProperties(getFormData(), completionHandler: {(success, error) -> Void in
            if error != nil {
                
            } else {
                
            }
        })
    }
    private func getFormData() -> [NSObject:AnyObject] {
        var formData = [String:String]()
        formData[CwnuTag.KAKAO_REALNAME] = self.nameTF.text
        formData[CwnuTag.KAKAO_PHONE_NUM] = self.phoneTF.text
        
        if ((self.user?.properties[CwnuTag.KAKAO_THUMBNAIL_IMAGE] as? String) != nil) {
            formData[CwnuTag.KAKAO_THUMBPATH] = user!.properties[CwnuTag.KAKAO_THUMBNAIL_IMAGE] as? String
        }else {
            formData[CwnuTag.KAKAO_THUMBPATH] = "http://cinavro12.cafe24.com/cwnu/default/thumb_story.png"
        }
        if ((self.user?.properties[CwnuTag.KAKAO_NICKNAME] as? String) != nil) {
            formData[CwnuTag.KAKAO_NICK] = user!.properties[CwnuTag.KAKAO_NICKNAME] as? String
        }else {
            formData[CwnuTag.KAKAO_NICK] = "창대생"
        }
        
        
        return formData
    }
    
    
    
    
    
    // MARK -- Functions
    private func showWebView(){
        let url = "http://cinavro12.cafe24.com/cwnu/agree/agree_index.html"
        let requestURL = NSURL(string: url)
        let request = NSURLRequest(URL: requestURL!)
        self.agreeWebView.loadRequest(request)
    }
    
    //시나브로 서버에 사용자가 있는지 체크하는 함수
    private func checkCert() {
        let request : NSMutableURLRequest? = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/user/cwnu_check_user_info.php")!)
        
        request!.HTTPMethod = "POST"
        var kakaoid = ""
        if (self.user?.ID != nil) {
            kakaoid = String(self.user!.ID!)
        }else {
            kakaoid = "error!"
        }
        let postString = "kakaoid="+kakaoid
        
        request!.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request!)  { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            if responseString!.isEqualToString("Y") {
                //성공시 MainViewController로 이동한다.
                print("성공")
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    let mControl = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                    self.navigationController?.pushViewController(mControl, animated: true)
                }
            }else {
                print("실패")
                self.hiddenView.hidden = true
            }
        }
        task.resume()
    }
    private func scanBarcode () {
        let alert = UIAlertController(title: "학생증 인증", message:"학생증으로 창원대 학생임을 인증하세요", preferredStyle: .Alert)
        let action = UIAlertAction(title: "인증하기", style: .Default) { _ in
            let cbControl = self.storyboard?.instantiateViewControllerWithIdentifier("CaptureBarcodeViewController") as! CaptureBarcodeViewController
            self.navigationController?.pushViewController(cbControl, animated: true)
        }
        let cancel = UIAlertAction(title: "건너뛰기", style: .Cancel, handler: { _ in
            let mControl = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
            self.navigationController?.pushViewController(mControl, animated: true)
        })
        alert.addAction(action)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true){}
    }
    
    
    private func requestCert()  {
        //여기 다 thumbnail_imge-> thumb_path로 , 카카오 아이디, 전화번호, 이름 넣기
        print(user?.ID)
        print(user?.properties)
        
        let realname = self.nameTF.text
        let phonenum = self.phoneTF.text
        let schoolnum = "iphone_school_num"
        let pushtoken = "iphone_token"
        
        var kakaoid = "iphone_kakao_id"
        var nickname = "iphone_nick_name"
        var thumbnailimage = "iphone_thumb_img"
        
        if (self.user?.ID != nil) {
            kakaoid = String(self.user!.ID!)
        }else {
            kakaoid = "error!"
        }
        if ((self.user?.properties[CwnuTag.KAKAO_THUMBNAIL_IMAGE] as? String) != nil) {
            thumbnailimage = (user!.properties[CwnuTag.KAKAO_THUMBNAIL_IMAGE] as? String)!
        }else {
            thumbnailimage = "http://cinavro12.cafe24.com/cwnu/default/thumb_story.png"
        }
        if ((self.user?.properties[CwnuTag.KAKAO_NICKNAME] as? String) != nil) {
            nickname = (user!.properties[CwnuTag.KAKAO_NICKNAME] as? String)!
        }else {
            nickname = "창대생"
        }
        
        
        let request : NSMutableURLRequest? = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/user/cwnu_upload_user_info.php")!)
        
        var postString = "realname="+realname!
        postString += "&phonenum="+phonenum!
        postString += "&schoolnum="+schoolnum
        postString += "&kakaoid="+kakaoid
        postString += "&nickname="+nickname
        postString += "&thumbnailimage="+thumbnailimage
        postString += "&pushtoken="+pushtoken
        
        
        
        request!.HTTPMethod = "POST"
        
        
        request!.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request!)  { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")

        }
        task.resume()
        
    }
    
    
    
    //MARK - IBAction
    @IBAction func actCert(sender: AnyObject) {
        if self.nameTF.text == "" || self.phoneTF.text == "" {
            
        }else {
            self.requestCert()
            self.updateKakao()
            self.scanBarcode()
        }
    }
    @IBAction func actAgree(sender: AnyObject) {
        agreeView.hidden = true
    }
    @IBAction func actCancel(sender: AnyObject) {
        UIView.animateWithDuration(1.0, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransformMakeTranslation(0, 200);
            }, completion: nil)
        cancelBtn.hidden = true
        
    }
    
}
