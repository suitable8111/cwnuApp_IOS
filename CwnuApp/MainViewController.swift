//
//  MainViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 3..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit
//import Google

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var freeBoardBtn: UIButton!
    @IBOutlet var trafficBtn: UIButton!
    @IBOutlet var foodMenuBtn: UIButton!
    @IBOutlet var schoolMapBtn: UIButton!
    @IBOutlet var wagleBtn: UIButton!
    @IBOutlet var councilBtn: UIButton!
    @IBOutlet var circleBtn: UIButton!
    @IBOutlet var tbNotice: UITableView!
    @IBOutlet var noticeView: UIView!
    @IBOutlet var noticeBtn: UIButton!
    
    @IBOutlet var noticeLb: UILabel!
    
    var noticeDataModel : NoticeDataModel?
    
    func initNoticeDataModel() -> NoticeDataModel! {
        if self.noticeDataModel == nil {
            noticeDataModel = NoticeDataModel()
        }
        return noticeDataModel
    }
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "(아이폰)메인화면")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //noticeView.hidden = true
        initNoticeDataModel()
        tbNotice.delegate = self
        tbNotice.dataSource = self
        noticeDataModel?.beginParsing()
    
        noticeLb.text = noticeDataModel?.posts.objectAtIndex(0).valueForKey(CwnuTag.NOTICE_TITLE) as? String
    }
    //TABLEVIEW DELGATE
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (noticeDataModel?.posts.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tbNotice.dequeueReusableCellWithIdentifier("NoticeInfoCell", forIndexPath: indexPath) as! NoticeInfoTableViewCell
        
        cell.titleLb.text = noticeDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.NOTICE_TITLE) as? String
        
        let postTime : NSString = (noticeDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.NOTICE_POST_TIME) as? NSString)!
        
        cell.postTimeLb.text = postTime.substringWithRange(NSRange(location: 2, length: 8))
        
        return cell
    }
    
    //
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "freeboard":
            let bvControl = segue.destinationViewController as! BoardViewController
            bvControl.boardType = "FREE"
            break
        case "councilboard":
            let bvControl = segue.destinationViewController as! BoardViewController
            bvControl.boardType = "COUNCIL"
            break
        case "NoticeCell":
            let wgDControl = segue.destinationViewController as! WagleDetailViewController
            wgDControl.type = "MainNotice"
            wgDControl.boardId = noticeDataModel?.posts.objectAtIndex((tbNotice.indexPathForSelectedRow?.row)!).valueForKey(CwnuTag.NOTICE_CONTENT) as! String
            break
        default :
            break
        }
    }
    @IBAction func actNotice(sender: AnyObject) {
        noticeView.hidden = false
        
    }
    @IBAction func actNoticeExit(sender: AnyObject) {
        noticeView.hidden = true
    }
}
class NoticeDataModel: NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var element = NSString()
    var elements = NSMutableDictionary()
    
    private var titleStr = NSMutableString()
    private var contentStr = NSMutableString()
    private var postTimeStr = NSMutableString()
    
    
    
    
    func beginParsing(){
        var stringURL = "http://cinavro12.cafe24.com/cwnu/notice/cwnu_notice_xml.php"
        
        
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
            postTimeStr = NSMutableString()
            postTimeStr = ""
            contentStr = NSMutableString()
            contentStr = ""
            titleStr = NSMutableString()
            titleStr = ""
        }
    }
    @objc func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString(CwnuTag.BOARD_ROW) {
            
            if !postTimeStr.isEqual(nil) {
                elements.setObject(postTimeStr, forKey: CwnuTag.NOTICE_POST_TIME)
            }
            if !contentStr.isEqual(nil) {
                elements.setObject(contentStr, forKey: CwnuTag.NOTICE_CONTENT)
            }
            if !titleStr.isEqual(nil) {
                elements.setObject(titleStr, forKey: CwnuTag.NOTICE_TITLE)
            }
            posts.addObject(elements)
            
            
        }
        
    }
    @objc func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString(CwnuTag.NOTICE_POST_TIME){
            postTimeStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.NOTICE_CONTENT){
            contentStr.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.NOTICE_TITLE){
            titleStr.appendString(replaceSpecialChar(string))
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
