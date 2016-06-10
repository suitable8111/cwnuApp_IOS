//
//  BoardViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 3. 8..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit
//import Google

class BoardViewController : UIViewController,UIScrollViewDelegate, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var navigaionBar: UIView!
    @IBOutlet var tbView: UITableView!
    @IBOutlet var typeLabel: UILabel!
    
    var boardType : String?
    var user : KOUser?
    var boardDataModel : BoardDataModel?
    var indexNum = 0;
    var isReload : Bool = false
    func boardDatdModelInit () -> BoardDataModel! {
        if boardDataModel == nil {
            boardDataModel = BoardDataModel()
        }
        
        return boardDataModel
    }
    func reloadViews(){
        sleep(1)
        if boardDataModel != nil {
            boardDataModel?.posts.removeAllObjects()
            boardDataModel?.beginParsing(boardType!, index: indexNum)
            tbView.reloadData()
        }
    }
    override func viewDidLoad() {
        self.boardDatdModelInit()
        self.tbView.delegate = self
        self.tbView.dataSource = self
        
        self.navigaionBar.backgroundColor = ColorExtension.myColor1()
        switch self.boardType! {
        case "FREE":
            self.typeLabel.text = "창원대 대나무 숲"
            break
        case "COUNCIL":
            self.typeLabel.text = "총학생회 게시판"
            break
        default:
            break
        }
    }
//    
    override func viewWillAppear(animated: Bool) {
        self.requestMe()
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "(아이폰)게시판화면")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
            case "AddPost":
                let apControl = segue.destinationViewController as! AddPostViewController
                switch self.boardType! {
                case "FREE":
                    apControl.CATEGORY = CwnuTag.BOARD_POST_TYPE_BOARD
                    break
                case "COUNCIL":
                    apControl.CATEGORY = CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL
                    break
                default:
                    break
                }
                break
            case "boardDetail":
                let bdControl = segue.destinationViewController as! BoardDetailViewController
                bdControl.bdDic = boardDataModel?.posts.objectAtIndex((self.tbView.indexPathForSelectedRow?.row)!) as! NSDictionary
                bdControl.boardType = self.boardType
                uplaodViewCount(boardDataModel?.posts.objectAtIndex((self.tbView.indexPathForSelectedRow?.row)!).valueForKey(CwnuTag.BOARD_ID) as! String)
                break
        default :
                break
        }

    }
    //Kakao Request....
    private func requestMe(displayResult: Bool = false) {
        
        KOSessionTask.meTaskWithCompletionHandler { [weak self] (user, error) -> Void in
            if error != nil {
                
            } else {
                self?.user = (user as! KOUser)
                self!.reloadViews()
            }
        }
        
    }
    
    //TABLE VIEW DELEGATE
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCellWithIdentifier("BoardCell", forIndexPath: indexPath) as! BoardTableViewCell
        
        cell.updateBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        
        cell.updateBtn.addTarget(self, action: #selector(BoardViewController.cellUpdateClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(BoardViewController.cellDeleteClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.updateBtn.hidden = true
        cell.deleteBtn.hidden = true
        
        if (boardDataModel!.posts.count != 0) {
            cell.titleLabel.text = boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_TITLE) as? String
            cell.nameLabel.text = boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_NAME) as? String
//            if (boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_COMMENTCOUNT) as? String) == "null"{
//                cell.commentLabel.text = "댓글 : +0"
//            }else {
//                cell.commentLabel.text = "댓글 : +"+(boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_COMMENTCOUNT) as? String)!
//            }
//            if (boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_GOODCOUNT) as? String) == "null"{
//                cell.goodLabel.text = "좋아요 : 0"
//            }else {
//                cell.goodLabel.text = "좋아요 : "+(boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_GOODCOUNT) as? String)!
//            }
            
            if (boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_VIEWCOUNT) as? String) == "zero"{
                cell.viewCountLabel.text = "조회수 : 0"
            }else {
                cell.viewCountLabel.text = "조회수 : "+(boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_VIEWCOUNT) as? String)!
            }
            let postTime : NSString = (boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_POSTTIME) as? NSString)!
            
            cell.postTimeLabel.text = postTime.substringWithRange(NSRange(location: 2, length: 8))
            
            cell.thumbNailImge.layer.cornerRadius = 20
            cell.thumbNailImge.layer.masksToBounds = true
            cell.thumbNailImge.downloadedFrom(link: boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_KAKAOTHUMBNAIL) as! String, contentMode: UIViewContentMode.ScaleToFill)
            
            if user != nil {
                if (boardDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BOARD_KAKAOID) as! String) == user!.ID.stringValue{
                    cell.updateBtn.hidden = false
                    cell.deleteBtn.hidden = false
                }
            }
            
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.whiteColor()
        }else {
            cell.backgroundColor = UIColor(red: 247.0/255, green: 247.0/255, blue: 247.0/255, alpha: 1.0)
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (boardDataModel!.posts.count != 0) {
            return boardDataModel!.posts.count;
        }else{
            return 0;
        }
    }
    func uplaodViewCount(boardid : String) {
        
        var request : NSMutableURLRequest?
        switch self.boardType! {
        case "FREE":
            request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board/cwnu_upload_view_count.php")!)
            break
        case "COUNCIL":
            request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board_concil/cwnu_upload_view_count.php")!)
            break
        default:
            break
        }
        
        var postString : String = ""
        
        postString = "boardid="+boardid
        
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
//    테이블 뷰 버튼 클릭메소드
    func cellUpdateClicked(sender:UIButton) {
        
        print("업데이트")
        print(sender.tag)
        
        let apControl = self.storyboard?.instantiateViewControllerWithIdentifier("AddPostViewController") as! AddPostViewController
        switch self.boardType! {
        case "FREE":
            apControl.CATEGORY = CwnuTag.BOARD_POST_TYPE_BOARD_UPDATE
            break
        case "COUNCIL":
            apControl.CATEGORY = CwnuTag.BOARD_POST_TYPE_BOARD_COUNCIL_UPDATE
            break
        default:
            break
        }
        
        apControl.updateDic = boardDataModel?.posts.objectAtIndex(sender.tag) as? NSDictionary
        apControl.BOARDID = (boardDataModel?.posts.objectAtIndex(sender.tag).valueForKey(CwnuTag.BOARD_ID) as? String)!
        self.navigationController?.pushViewController(apControl, animated: true)
    }
    func cellDeleteClicked(sender:UIButton) {
        print("딜리트")
        print(sender.tag)
        
        
        //서버 제거
        var request : NSMutableURLRequest? = nil
        
        var postString : String = ""
        
        print(boardDataModel?.posts.objectAtIndex(sender.tag).valueForKey(CwnuTag.BOARD_ID) as! String)
        print(user?.ID.stringValue)
        
        switch self.boardType! {
        case "FREE":
            request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board/cwnu_delete_post.php")!)
            break
        case "COUNCIL":
            request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/board_concil/cwnu_delete_post.php")!)
            break
        default:
            break
        }
        
        postString = "boardid="+((boardDataModel?.posts.objectAtIndex(sender.tag).valueForKey(CwnuTag.BOARD_ID))! as! String)+"&kakaoid="+(user?.ID.stringValue)!
        
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
        boardDataModel?.posts.removeObjectAtIndex(sender.tag)
        tbView.reloadData()
        
    }
    
    
    /////////////////////

    
    //Navi Back

    func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        switch scrollView {
        case tbView :
            let offset : CGPoint = tbView.contentOffset
            let bounds : CGRect = tbView.bounds
            let size : CGSize = tbView.contentSize
            let inset : UIEdgeInsets = tbView.contentInset
            
            let y : CGFloat = offset.y + bounds.size.height - inset.bottom
            let h : CGFloat = size.height
            
            let nextValue : CGFloat = 10
            if (y > h + nextValue) {
                self.isReload = true
                reloadData(boardType!)
            }
            break
        default :
            break
        }
    }
    func reloadData(boardType : String) {
        if self.isReload == true {
            indexNum += 1
            
            //allAryOne?.addObjectsFromArray(self.parserHTML(0,currPage: currpageOne) as [AnyObject])
            boardDataModel?.beginParsing(boardType, index: indexNum)
            tbView.reloadData()
            self.isReload = false
        }
    }

}

//서버에 저장되어있는 게시판 정보 xml 를 파싱해주는 코드

class BoardDataModel: NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var element = NSString()
    var elements = NSMutableDictionary()
    
    private var idStr = NSMutableString()
    private var nameStr = NSMutableString()
    private var titleStr = NSMutableString()
    private var contextStr = NSMutableString()
    private var kakaoidStr = NSMutableString()
    private var kakaothumbnailStr = NSMutableString()
    private var posttimeStr = NSMutableString()
    private var commentCountStr = NSMutableString()
    private var goodCountStr = NSMutableString()
    private var viewCountStr = NSMutableString()
    
    
    
    
    func beginParsing(boardType : String, index : Int){
        var stringURL = ""
        
        
        switch boardType {
        case "FREE":
            stringURL = "http://cinavro12.cafe24.com/cwnu/board/cwnu_board_xml.php?index="+String(index)
            break
        case "COUNCIL":
            stringURL = "http://cinavro12.cafe24.com/cwnu/board_concil/cwnu_board_xml.php?index="+String(index)
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
            titleStr = NSMutableString()
            titleStr = ""
            contextStr = NSMutableString()
            contextStr = ""
            kakaoidStr = NSMutableString()
            kakaoidStr = ""
            kakaothumbnailStr = NSMutableString()
            kakaothumbnailStr = ""
            posttimeStr = NSMutableString()
            posttimeStr = ""
            commentCountStr = NSMutableString()
            commentCountStr = ""
            goodCountStr = NSMutableString()
            goodCountStr = ""
            viewCountStr = NSMutableString()
            viewCountStr = ""
        }
    }
    @objc func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString(CwnuTag.BOARD_ROW) {
            
            if !idStr.isEqual(nil) {
                elements.setObject(idStr, forKey: CwnuTag.BOARD_ID)
            }
            if !nameStr.isEqual(nil) {
                elements.setObject(nameStr, forKey: CwnuTag.BOARD_NAME)
            }
            if !titleStr.isEqual(nil) {
                elements.setObject(titleStr, forKey: CwnuTag.BOARD_TITLE)
            }
            if !contextStr.isEqual(nil) {
                elements.setObject(contextStr, forKey: CwnuTag.BOARD_CONTEXT)
            }
            if !kakaoidStr.isEqual(nil) {
                elements.setObject(kakaoidStr, forKey: CwnuTag.BOARD_KAKAOID)
            }
            if !kakaothumbnailStr.isEqual(nil) {
                elements.setObject(kakaothumbnailStr, forKey: CwnuTag.BOARD_KAKAOTHUMBNAIL)
            }
            if !posttimeStr.isEqual(nil) {
                elements.setObject(posttimeStr, forKey: CwnuTag.BOARD_POSTTIME)
            }
            if !commentCountStr.isEqual(nil) {
                elements.setObject(commentCountStr, forKey: CwnuTag.BOARD_COMMENTCOUNT)
            }
            if !goodCountStr.isEqual(nil) {
                elements.setObject(goodCountStr, forKey: CwnuTag.BOARD_GOODCOUNT)
            }
            if !viewCountStr.isEqual(nil) {
                elements.setObject(viewCountStr, forKey: CwnuTag.BOARD_VIEWCOUNT)
            }
            posts.addObject(elements)
            
            
        }
        
    }
    @objc func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString(CwnuTag.BOARD_ID){
            idStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BOARD_NAME){
            nameStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BOARD_TITLE){
            titleStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BOARD_CONTEXT){
            contextStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BOARD_KAKAOID){
            kakaoidStr.appendString(replaceSpecialCharAndTiff(string))
        }else if element.isEqualToString(CwnuTag.BOARD_KAKAOTHUMBNAIL){
            kakaothumbnailStr.appendString(replaceSpecialCharAndTiff(string))
        }else if element.isEqualToString(CwnuTag.BOARD_POSTTIME){
            posttimeStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BOARD_COMMENTCOUNT){
            commentCountStr.appendString(replaceSpecialCharAndTiff(string))
        }else if element.isEqualToString(CwnuTag.BOARD_GOODCOUNT){
            goodCountStr.appendString(replaceSpecialCharAndTiff(string))
        }else if element.isEqualToString(CwnuTag.BOARD_VIEWCOUNT){
            viewCountStr.appendString(replaceSpecialCharAndTiff(string))
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




