//
//  AddPostViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 3. 9..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

class AddPostViewController : UIViewController {
    
    var CATEGORY : String = ""
    var BOARDID : String = ""
    var updateDic : NSDictionary?
    
    var isAnonymous : Bool = false
    
    private var user:KOUser? = nil
    
    
    @IBOutlet var viewTitleLabel: UILabel!
    @IBOutlet var titleTxtF: UITextField!
    @IBOutlet var contextTxtF: UITextField!
    @IBOutlet var anonySwitch: UISwitch!
    @IBOutlet var anonyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMe()
        
        
        
        switch CATEGORY {
            case CwnuTag.BOARD_POST_TYPE_BOARD :
                viewTitleLabel.text = "글쓰기"
            break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COMMENT :
                viewTitleLabel.text = "댓글달기"
                titleTxtF.text = "Comment"
                titleTxtF.hidden = true
            break
            
            case CwnuTag.BOARD_POST_TYPE_BOARD_UPDATE :
                if updateDic != nil {
                    titleTxtF.text = updateDic!.valueForKey(CwnuTag.BOARD_TITLE) as? String
                    contextTxtF.text = updateDic!.valueForKey(CwnuTag.BOARD_CONTEXT) as? String
                }
                viewTitleLabel.text = "게시물 수정하기"
            break
            case CwnuTag.BOARD_POST_TYPE_BOARD_UPDATE_COMMET :
                viewTitleLabel.text = "댓글수정"
                titleTxtF.text = "CommentUpdate"
                if updateDic != nil {
                    contextTxtF.text = updateDic!.valueForKey(CwnuTag.BOARD_CONTEXT) as? String
                }
                titleTxtF.hidden = true
            break
            
            //COUNCIL
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL :
                viewTitleLabel.text = "글쓰기"
            break
                
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_COMMENT :
                viewTitleLabel.text = "댓글달기"
                titleTxtF.text = "Comment"
                titleTxtF.hidden = true
            break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE :
                if updateDic != nil {
                    titleTxtF.text = updateDic!.valueForKey(CwnuTag.BOARD_TITLE) as? String
                    contextTxtF.text = updateDic!.valueForKey(CwnuTag.BOARD_CONTEXT) as? String
                }
            viewTitleLabel.text = "게시물 수정하기"
            break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE_COMMET :
                viewTitleLabel.text = "댓글수정"
                titleTxtF.text = "CommentUpdate"
                if updateDic != nil {
                    contextTxtF.text = updateDic!.valueForKey(CwnuTag.BOARD_CONTEXT) as? String
                }
            titleTxtF.hidden = true
            break
            
            default :
            break
            
        }
        
    }
    private func requestMe(displayResult: Bool = false) {
        
        KOSessionTask.meTaskWithCompletionHandler { [weak self] (user, error) -> Void in
            if error != nil {
                
            } else {
                self?.user = (user as! KOUser)
            }
        }
        
    }
    func goAlert(string : String) {
        let alert = UIAlertController(title: "오류", message:string, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "취소", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true){}
    }
    @IBAction func actAddPost(sender: AnyObject) {
        if titleTxtF.text=="" {
            goAlert("제목을 넣어주세요")
        }else if contextTxtF.text=="" {
            goAlert("내용을 넣어주세요")
        }else if user == nil{
            goAlert("전송에 실패했습니다 다시해주세요")
            self.navigationController?.popViewControllerAnimated(true)
        }else {
            addPost(CATEGORY)
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func addPost(category : String){
        let userID : String = (user?.ID.stringValue)!
        let userThumb : String = user?.properties["thumb_path"] as! String
        let userNick : String = (user?.properties["nick"])! as! String
        let anonyThumb : String = "http://cinavro12.cafe24.com/cwnu/default/thumb_story.png"
        if anonySwitch.on {
            switch category {
            case CwnuTag.BOARD_POST_TYPE_BOARD :
                requestPost(category,userID,anonyThumb,"익명")
                break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COMMENT :
                requestPost(category,userID,anonyThumb,"익명",BOARDID)
                break
            case CwnuTag.BOARD_POST_TYPE_BOARD_UPDATE :
                requestPost(category,userID,BOARDID)
                break
            case CwnuTag.BOARD_POST_TYPE_BOARD_UPDATE_COMMET :
                requestPost(category,userID,BOARDID)
                break
            
            //COUNCIL
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL :
                requestPost(category,userID,anonyThumb,"익명")
                break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_COMMENT :
                requestPost(category,userID,anonyThumb,"익명",BOARDID)
                break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE :
                requestPost(category,userID,BOARDID)
                break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE_COMMET :
                requestPost(category,userID,BOARDID)
                break
            default :
                break
            }
        }else {
            switch category {
                case CwnuTag.BOARD_POST_TYPE_BOARD :
                    requestPost(category,userID,userThumb,userNick)
                break
                case CwnuTag.BOARD_POST_TYPE_BOARD_COMMENT :
                    requestPost(category,userID,userThumb,userNick,BOARDID)
                break
                case CwnuTag.BOARD_POST_TYPE_BOARD_UPDATE :
                    requestPost(category,userID,BOARDID)
                break
                case CwnuTag.BOARD_POST_TYPE_BOARD_UPDATE_COMMET :
                    requestPost(category,userID,BOARDID)
                break
                
                //COUNCIL
                case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL :
                    requestPost(category,userID,anonyThumb,userNick)
                break
                case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_COMMENT :
                    requestPost(category,userID,userThumb,userNick,BOARDID)
                break
                case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE :
                    requestPost(category,userID,BOARDID)
                break
                case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE_COMMET :
                    requestPost(category,userID,BOARDID)
                break
                default :
                break
            
            }
        }
    }
    func requestPost(parms : String...){
        var request : NSMutableURLRequest? = nil
        
        var postString : String = ""
        
        switch parms[0] {
            case CwnuTag.BOARD_POST_TYPE_BOARD :
                request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board/cwnu_upload_post.php")!)
                postString = "title="+titleTxtF.text!+"&context="+contextTxtF.text!+"&kakaoid="+parms[1]+"&kakaothumbnail="+parms[2]+"&name="+parms[3]
            break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COMMENT :
                request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board/comment/cwnu_upload_comment.php")!)
                postString = "context="+contextTxtF.text!+"&kakaoid="+parms[1]+"&kakaothumbnail="+parms[2]+"&name="+parms[3]+"&boardid="+parms[4]
            break
            case CwnuTag.BOARD_POST_TYPE_BOARD_UPDATE :
                request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board/cwnu_update_post.php")!)
                postString = "kakaoid="+parms[1]+"&title="+titleTxtF.text!+"&context="+contextTxtF.text!+"&boardid="+parms[2]
            break
            case CwnuTag.BOARD_POST_TYPE_BOARD_UPDATE_COMMET :
                request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board/comment/cwnu_update_comment.php")!)
                postString = "kakaoid="+parms[1]+"&context="+contextTxtF.text!+"&boardid="+parms[2]
            break
            
            //COUNCIL
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL :
                request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board_concil/cwnu_upload_post.php")!)
                postString = "title="+titleTxtF.text!+"&context="+contextTxtF.text!+"&kakaoid="+parms[1]+"&kakaothumbnail="+parms[2]+"&name="+parms[3]
            break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_COMMENT :
                request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board_concil/comment_concil/cwnu_upload_comment.php")!)
                postString = "context="+contextTxtF.text!+"&kakaoid="+parms[1]+"&kakaothumbnail="+parms[2]+"&name="+parms[3]+"&boardid="+parms[4]
            break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE :
                request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board_concil/cwnu_update_post.php")!)
                postString = "kakaoid="+parms[1]+"&title="+titleTxtF.text!+"&context="+contextTxtF.text!+"&boardid="+parms[2]
            break
            case CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE_COMMET :
                request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board_concil/comment_concil/cwnu_update_comment.php")!)
                postString = "kakaoid="+parms[1]+"&context="+contextTxtF.text!+"&boardid="+parms[2]
            break
            
            default :
            break
        }
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
    
    @IBAction func actSwitch(sender: AnyObject) {
        if anonySwitch.on {
            anonyLabel.text = "익명"
        } else {
            anonyLabel.text = "익명하기"
        }
    }
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
