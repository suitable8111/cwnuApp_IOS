//
//  BoardDetailViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 4..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit


class BoardDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var boardIdLabel: UILabel!
    @IBOutlet var thumbImg: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var postTimeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var goodLabel: UILabel!
    @IBOutlet var contextLabel: UITextView!
    @IBOutlet var tbView: UITableView!
    @IBOutlet var viewCountLabel: UILabel!
    
    @IBOutlet var goodBtn: UIButton!
    
    var isGood : Bool = false
    var user : KOUser?
    var bdDic = NSDictionary()
    var boardType : String?
    var boardDetailDataModel : BoardDetailDataModel?
    func boardDetailDataModelintit() -> BoardDetailDataModel! {
        if boardDetailDataModel == nil {
            boardDetailDataModel = BoardDetailDataModel()
        }
        return boardDetailDataModel
    }
    func reloadViews(){
        sleep(1)
        if boardDetailDataModel != nil {
            boardDetailDataModel?.posts.removeAllObjects()
            boardDetailDataModel?.beginParsing((bdDic.valueForKey(CwnuTag.BOARD_COMMENT_ID) as? String)!, boardType: self.boardType!)
            tbView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //titleLabel.text = bdDic.valueForKey(CwnuTag.BOARD_TITLE) as? String
        boardIdLabel.text = "["+(bdDic.valueForKey(CwnuTag.BOARD_ID) as? String)!+"번 째 대나무숲]"
        nameLabel.text = bdDic.valueForKey(CwnuTag.BOARD_NAME) as? String
        if (bdDic.valueForKey(CwnuTag.BOARD_VIEWCOUNT) as? String) == "zero"{
            viewCountLabel.text = "조회수 : 0"
        }else {
            viewCountLabel.text = "조회수 : "+(bdDic.valueForKey(CwnuTag.BOARD_VIEWCOUNT) as? String)!
        }
        
        
        let replaceString = (bdDic.valueForKey(CwnuTag.BOARD_POSTTIME) as? String)!
     
        let postTime : NSString = replaceString.stringByReplacingOccurrencesOfString("-", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil) as NSString
        print(postTime)
        postTimeLabel.text = postTime.substringWithRange(NSRange(location: 2, length: 14))
        
        commentLabel.text = bdDic.valueForKey(CwnuTag.BOARD_COMMENTCOUNT) as? String
        goodLabel.text = bdDic.valueForKey(CwnuTag.BOARD_GOODCOUNT) as? String
        //contextLabel.text = bdDic.valueForKey(CwnuTag.BOARD_CONTEXT) as? String
        
        
        if (bdDic.valueForKey(CwnuTag.BOARD_COMMENTCOUNT) as? String) == "null"{
            commentLabel.text = "댓글 : +0"
        }else {
            commentLabel.text = "댓글 : +"+(bdDic.valueForKey(CwnuTag.BOARD_COMMENTCOUNT) as? String)!
        }
        if (bdDic.valueForKey(CwnuTag.BOARD_GOODCOUNT) as? String) == "null"{
            goodLabel.text = "좋아요 : 0"
        }else {
            goodLabel.text = "좋아요 : +"+(bdDic.valueForKey(CwnuTag.BOARD_GOODCOUNT) as? String)!
        }
        
        thumbImg.layer.cornerRadius = 12
        thumbImg.layer.masksToBounds = true
        thumbImg.downloadedFrom(link: bdDic.valueForKey(CwnuTag.BOARD_KAKAOTHUMBNAIL) as! String, contentMode: UIViewContentMode.ScaleToFill)
        
        tbView.delegate = self
        tbView.dataSource = self
        
        tbView.rowHeight = UITableViewAutomaticDimension
        tbView.estimatedRowHeight = 70;
        boardDetailDataModelintit()
//        boardDetailDataModel?.beginParsing((bdDic.valueForKey(CwnuTag.BOARD_COMMENT_ID) as? String)!)
        
        titleLabel.attributedText = underlining((bdDic.valueForKey(CwnuTag.BOARD_TITLE) as? String)!, size: 6)
        contextLabel.attributedText = underlining((bdDic.valueForKey(CwnuTag.BOARD_CONTEXT) as? String)!, size: 6)
    }
    override func viewWillAppear(animated: Bool) {
        requestMe()
    }
    func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //Kakao Request....
    private func requestMe(displayResult: Bool = false) {
        
        KOSessionTask.meTaskWithCompletionHandler { [weak self] (user, error) -> Void in
            if error != nil {
                
            } else {
                self?.user = (user as! KOUser)
                self?.reloadViews()
            }
        }
        
    }
    //TableView Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCellWithIdentifier("DetailBoardCell", forIndexPath: indexPath) as! BoardDetailTableViewCell
        
        cell.updateBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        
        cell.updateBtn.addTarget(self, action: #selector(detailCellUpdateClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(detailCellDeleteClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.updateBtn.hidden = true
        cell.deleteBtn.hidden = true
        
        if (boardDetailDataModel!.posts.count != 0) {
            cell.nameLabel.text = boardDetailDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_COMMENT_NAME) as? String
            cell.contentLabel.text = boardDetailDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_COMMENT_CONTEXT) as? String
            
            cell.postTimeLabel.text = boardDetailDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_COMMENT_POSTTIME) as? String
            
            cell.contentLabel.sizeToFit()
            
            
            cell.detailThumbnailImage.layer.cornerRadius = 12
            cell.detailThumbnailImage.layer.masksToBounds = true
            cell.detailThumbnailImage.downloadedFrom(link: boardDetailDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_COMMENT_KAKAOTHUMBNAIL) as! String, contentMode: UIViewContentMode.ScaleToFill)
            
            if user != nil {
                if (boardDetailDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_KAKAOID) as! String) == user!.ID.stringValue{
                    cell.updateBtn.hidden = false
                    cell.deleteBtn.hidden = false
                }
            }
            
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (boardDetailDataModel!.posts.count != 0) {
            return boardDetailDataModel!.posts.count;
        }else{
            return 0
        }
    }
    
    //    테이블 뷰 버튼 클릭메소드
    func detailCellUpdateClicked(sender:UIButton) {
        print("업데이트")
        print(sender.tag)
        
        let apControl = self.storyboard?.instantiateViewControllerWithIdentifier("AddPostViewController") as! AddPostViewController
        switch self.boardType! {
        case "FREE":
            apControl.CATEGORY = CwnuTag.BOARD_POST_TYPE_BOARD_UPDATE_COMMET
            break
        case "COUNCIL":
            apControl.CATEGORY = CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE_COMMET
            break
        default:
            break
        }
        
        apControl.updateDic = boardDetailDataModel?.posts.objectAtIndex(sender.tag) as? NSDictionary
        apControl.BOARDID = (boardDetailDataModel?.posts.objectAtIndex(sender.tag).valueForKey(CwnuTag.BOARD_COMMENT_ID) as? String)!
        self.navigationController?.pushViewController(apControl, animated: true)
    }
    func detailCellDeleteClicked(sender:UIButton) {
        print("딜리트")
        print(sender.tag)
        
        //서버 제거
        var request : NSMutableURLRequest? = nil
        
        var postString : String = ""
        
        print(boardDetailDataModel?.posts.objectAtIndex(sender.tag).valueForKey(CwnuTag.BOARD_COMMENT_ID) as! String)
        print(user?.ID.stringValue)
        switch self.boardType! {
        case "FREE":
            request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board/comment/cwnu_delete_comment.php")!)
            break
        case "COUNCIL":
            request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board_concil/comment_concil/cwnu_delete_comment.php")!)
            break
        default:
            break
        }
        postString = "id="+((boardDetailDataModel?.posts.objectAtIndex(sender.tag).valueForKey(CwnuTag.BOARD_COMMENT_ID))! as! String)+"&kakaoid="+(user?.ID.stringValue)!+"&boardid="+(bdDic.valueForKey(CwnuTag.BOARD_ID) as? String)!
        
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
        
        
        //Local 제거
        boardDetailDataModel?.posts.removeObjectAtIndex(sender.tag)
        tbView.reloadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "addComment":
            let apControl = segue.destinationViewController as! AddPostViewController
            
            switch self.boardType! {
            case "FREE":
                apControl.CATEGORY = CwnuTag.BOARD_POST_TYPE_BOARD_COMMENT
                break
            case "COUNCIL":
                apControl.CATEGORY = CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_COMMENT
                break
            default:
                break
            }
            
            apControl.BOARDID = (bdDic.valueForKey(CwnuTag.BOARD_COMMENT_ID) as? String)!
            break
        default :
            break
        }
    }
    
    func underlining(content : String,size: Int) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attrString = NSMutableAttributedString(string: content)
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle,range: NSMakeRange(0, attrString.length))
        return attrString
    }
    @IBAction func actGood(sender: AnyObject) {
        if !isGood {
            isGood = true
            goodBtn.setImage(UIImage(named: "board_gooded.png"), forState: UIControlState.Normal)
            var request : NSMutableURLRequest?
            switch self.boardType! {
            case "FREE":
                request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board/comment/cwnu_upload_good.php")!)
                break
            case "COUNCIL":
                request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board_concil/comment/cwnu_upload_good.php")!)
                break
            default:
                break
            }
        
            var postString : String = ""
            
            postString = "boardid="+(self.bdDic.valueForKey(CwnuTag.BOARD_ID) as? String)!
            
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
    }
}

class BoardDetailDataModel: NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var element = NSString()
    var elements = NSMutableDictionary()
    
    private var idStr = NSMutableString()
    private var nameStr = NSMutableString()
    private var contextStr = NSMutableString()
    private var kakaoidStr = NSMutableString()
    private var kakaothumbnailStr = NSMutableString()
    private var posttimeStr = NSMutableString()
    
    
    
    
    func beginParsing(boardid : String, boardType : String){
        var stringURL = ""
        switch boardType {
        case "FREE":
            stringURL = "http://cinavro12.cafe24.com/cwnu/board/comment/cwnu_board_comment_xml.php?boardid=" + boardid
            break
        case "COUNCIL":
            stringURL = "http://cinavro12.cafe24.com/cwnu/board_concil/comment_concil/cwnu_board_comment_xml.php?boardid=" + boardid
            break
        default:
            break
        }
        
        let s = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy()
        s.addCharactersInString("+&")
        stringURL = stringURL.stringByAddingPercentEncodingWithAllowedCharacters(s as! NSCharacterSet)!;
        let url = NSURL(string: stringURL)
        
        parser = NSXMLParser(contentsOfURL: url!)!
        parser.delegate = self
        parser.parse()
    }
    @objc func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
        if(elementName as NSString).isEqualToString(CwnuTag.BOARD_ROW){
            elements = NSMutableDictionary()
            elements = [:]
            idStr = NSMutableString()
            idStr = ""
            nameStr = NSMutableString()
            nameStr = ""
            contextStr = NSMutableString()
            contextStr = ""
            kakaoidStr = NSMutableString()
            kakaoidStr = ""
            kakaothumbnailStr = NSMutableString()
            kakaothumbnailStr = ""
            posttimeStr = NSMutableString()
            posttimeStr = ""
        
        }
    }
    @objc func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString(CwnuTag.BOARD_ROW) {
            
            if !idStr.isEqual(nil) {
                elements.setObject(idStr, forKey: CwnuTag.BOARD_COMMENT_ID)
            }
            if !nameStr.isEqual(nil) {
                elements.setObject(nameStr, forKey: CwnuTag.BOARD_COMMENT_NAME)
            }
            if !contextStr.isEqual(nil) {
                elements.setObject(contextStr, forKey: CwnuTag.BOARD_COMMENT_CONTEXT)
            }
            if !kakaoidStr.isEqual(nil) {
                elements.setObject(kakaoidStr, forKey: CwnuTag.BOARD_COMMENT_KAKAOID)
            }
            if !kakaothumbnailStr.isEqual(nil) {
                elements.setObject(kakaothumbnailStr, forKey: CwnuTag.BOARD_COMMENT_KAKAOTHUMBNAIL)
            }
            if !posttimeStr.isEqual(nil) {
                elements.setObject(posttimeStr, forKey: CwnuTag.BOARD_COMMENT_POSTTIME)
            }
            
            posts.addObject(elements)
            
            
        }
        
    }
    @objc func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString(CwnuTag.BOARD_COMMENT_ID){
            idStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BOARD_COMMENT_NAME){
            nameStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BOARD_COMMENT_CONTEXT){
            contextStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BOARD_COMMENT_KAKAOID){
            kakaoidStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BOARD_COMMENT_KAKAOTHUMBNAIL){
            kakaothumbnailStr.appendString(replaceSpecialCharAndTiff(string))
        }else if element.isEqualToString(CwnuTag.BOARD_COMMENT_POSTTIME){
            posttimeStr.appendString(replaceSpecialChar(string))
        }
    }
    func replaceSpecialChar(str:String) -> String{
        let str_change = NSMutableString(string: str)
        
        str_change.replaceOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        str_change.replaceOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        return str_change as String
    }
    func replaceSpecialCharAndTiff(str:String) -> String{
        let str_change = NSMutableString(string: str)
        
        str_change.replaceOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        str_change.replaceOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        str_change.replaceOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        return str_change as String
    }
    
    
}
