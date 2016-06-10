//
//  SchoolRoadContentViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 13..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

//대학로 정보 TableView 카테고리별 파싱을 시켜서
class SchoolRoadContentViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tbView: UITableView!
    
    var pageIndex : Int = 0
    var favorArray : NSMutableArray!
    
    
    var bestFoodDetailModel : BestFoodDataModel?
    
    func bestFoodDetailModelInit() -> BestFoodDataModel! {
        if self.bestFoodDetailModel == nil {
            self.bestFoodDetailModel = BestFoodDataModel()
        }
        return self.bestFoodDetailModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bestFoodDetailModelInit()
        self.bestFoodDetailModel!.beginParsing(self.pageIndex)
        self.tbView.delegate = self
        self.tbView.dataSource = self
        
        let path = getFileName("/bestFoodPList.plist")
        let fileManager = NSFileManager.defaultManager()
        // var isEqual = false
        
        if(!fileManager.fileExistsAtPath(path)){
            let orgPath = NSBundle.mainBundle().pathForResource("bestFoodPList", ofType: "plist")
            do {
                try fileManager.copyItemAtPath(orgPath!, toPath: path)
            } catch _ {
                
            }
        }
        self.favorArray = NSMutableArray(contentsOfFile: path)
        
        
        //favorAry가 없을 경우 안에 MutableDic를 생성
        if self.favorArray.count == 0 {
            self.favorArray.addObject(NSMutableDictionary(object: true, forKey: "0"))
        }
        
    }
    private func getFileName(fileName:String) -> String {
        let docsDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = docsDir[0]
        let fullName = docPath.stringByAppendingString(fileName)
        return fullName
    }
    // MARK -- TABLEVIEW DATASOURCE
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tbView.dequeueReusableCellWithIdentifier("SchoolRoadCell", forIndexPath: indexPath) as! SchoolRoadTableViewCell
        
        
        cell.goodBtn.tag = indexPath.row
        cell.callBtn.tag = indexPath.row
        
        
        let key = self.bestFoodDetailModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BEST_FOOD_ID) as? String
        
        let isGood = self.favorArray.objectAtIndex(0).valueForKey(key!) as? Bool
        
        if (isGood == nil || !isGood!){
            cell.goodBtn.setBackgroundImage(UIImage(named: "not_good_btn.png"), forState: UIControlState.Normal)
        }else {
            cell.goodBtn.setBackgroundImage(UIImage(named: "good_btn.png"), forState: UIControlState.Normal)
        }
        
        cell.callBtn.addTarget(self, action: #selector(sendCall(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.goodBtn.addTarget(self, action: #selector(sendGood(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.cateLabel.text = bestFoodDetailModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BEST_FOOD_TYPE) as? String
        cell.titleLabel.text = bestFoodDetailModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BEST_FOOD_NAME) as? String
            
        cell.goodCountLabel.text = bestFoodDetailModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BEST_FOOD_GOOD_COUNT) as? String
        
        cell.thumbnailImg.downloadedFrom(link: bestFoodDetailModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.BEST_FOOD_OUTDOOR_IMAGE) as! String, contentMode: UIViewContentMode.ScaleAspectFit)
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.bestFoodDetailModel?.posts.count)!
    }
    func sendCall(sender:UIButton) {
        print("전화걸었어요")
        let urlStirng : String = "tel://" + (self.bestFoodDetailModel?.posts.objectAtIndex(sender.tag).valueForKey(CwnuTag.BEST_FOOD_PHONE) as! String)
        let url = NSURL(string: urlStirng)
        UIApplication.sharedApplication().openURL(url!)
        
    }
    func sendGood(sender:UIButton) {
        
        let key = self.bestFoodDetailModel?.posts.objectAtIndex(sender.tag).valueForKey(CwnuTag.BEST_FOOD_ID)! as! String
        
        let isGood = self.favorArray.objectAtIndex(0).valueForKey(key) as? Bool
        let path = getFileName("/bestFoodPList.plist")
        //서버 보내기 NSURL request
        var request : NSMutableURLRequest? = nil
        //로컬에 값을 저장하고 이미지를 바꾸게 하는 기능
        if (isGood == nil || !isGood!) {
            
            self.favorArray.objectAtIndex(0).setObject(true, forKey: key)
            sender.setBackgroundImage(UIImage(named: "good_btn.png"), forState: UIControlState.Normal)
            request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/bestfood/cwnu_bestfood_good.php")!)
        }else {
            self.favorArray.objectAtIndex(0).setObject(false, forKey: key)
            sender.setBackgroundImage(UIImage(named: "not_good_btn.png"), forState: UIControlState.Normal)
            request = NSMutableURLRequest(URL: NSURL(string: "http://cinavro12.cafe24.com/cwnu/bestfood/cwnu_bestfood_good_cancel.php")!)
        }
        self.favorArray.writeToFile(path, atomically: true)
        
        //서버 보냄
        var postString : String = ""
    
        postString = "id="+((self.bestFoodDetailModel?.posts.objectAtIndex(sender.tag).valueForKey(CwnuTag.BEST_FOOD_ID))! as! String)
        
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
    
    //PrepereForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "schoolRoadDetail" {
            let srcControl = segue.destinationViewController as! SchoolRoadContentDetailViewController
            srcControl.srcDic = (bestFoodDetailModel?.posts.objectAtIndex((self.tbView.indexPathForSelectedRow?.row)!) as? NSDictionary)!
        }
    }
}


//대학로 xml 파싱
class BestFoodDataModel: NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var element = NSString()
    var elements = NSMutableDictionary()
    
    private var id = NSMutableString()
    private var name = NSMutableString()
    private var phone = NSMutableString()
    private var innerimagepath = NSMutableString()
    private var menuimagepath = NSMutableString()
    private var outdoorimagepath = NSMutableString()
    private var type = NSMutableString()
    private var context = NSMutableString()
    private var capacity = NSMutableString()
    private var opentime = NSMutableString()
    private var deilvery = NSMutableString()
    private var goodcount = NSMutableString()
    private var location = NSMutableString()
    private var lat = NSMutableString()
    private var long = NSMutableString()
    
    
    
    
    
    func beginParsing(indexNum : Int){
        var stringURL = ""
        switch indexNum {
        case 0:
            stringURL = "http://cinavro12.cafe24.com/cwnu/bestfood/cwnu_bestfood_xml.php?type=CAFETERIA"
            break
        case 1:
            stringURL = "http://cinavro12.cafe24.com/cwnu/bestfood/cwnu_bestfood_xml.php?type=DELIVERY"
            break
        case 2:
            stringURL = "http://cinavro12.cafe24.com/cwnu/bestfood/cwnu_bestfood_xml.php?type=COFFEE"
            break
        case 3:
            stringURL = "http://cinavro12.cafe24.com/cwnu/bestfood/cwnu_bestfood_xml.php?type=BAR"
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
            id = NSMutableString()
            id = ""
            name = NSMutableString()
            name = ""
            phone = NSMutableString()
            phone = ""
            innerimagepath = NSMutableString()
            innerimagepath = ""
            menuimagepath = NSMutableString()
            menuimagepath = ""
            outdoorimagepath = NSMutableString()
            outdoorimagepath = ""
            type = NSMutableString()
            type = ""
            context = NSMutableString()
            context = ""
            capacity = NSMutableString()
            capacity = ""
            opentime = NSMutableString()
            opentime = ""
            deilvery = NSMutableString()
            deilvery = ""
            goodcount = NSMutableString()
            goodcount = ""
            location = NSMutableString()
            location = ""
            lat = NSMutableString()
            lat = ""
            long = NSMutableString()
            long = ""
            
        }
    }
    @objc func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString(CwnuTag.BOARD_ROW) {
            
            if !id.isEqual(nil) {
                elements.setObject(id, forKey: CwnuTag.BEST_FOOD_ID)
            }
            if !name.isEqual(nil) {
                elements.setObject(name, forKey: CwnuTag.BOARD_NAME)
            }
            if !phone.isEqual(nil) {
                elements.setObject(phone, forKey: CwnuTag.BEST_FOOD_PHONE)
            }
            if !innerimagepath.isEqual(nil) {
                elements.setObject(innerimagepath, forKey: CwnuTag.BEST_FOOD_INNER_IMAGE)
            }
            if !menuimagepath.isEqual(nil) {
                elements.setObject(menuimagepath, forKey: CwnuTag.BEST_FOOD_MENU_IMAGE)
            }
            if !outdoorimagepath.isEqual(nil) {
                elements.setObject(outdoorimagepath, forKey: CwnuTag.BEST_FOOD_OUTDOOR_IMAGE)
            }
            if !type.isEqual(nil) {
                elements.setObject(type, forKey: CwnuTag.BEST_FOOD_TYPE)
            }
            if !context.isEqual(nil) {
                elements.setObject(context, forKey: CwnuTag.BEST_FOOD_CONTEXT)
            }
            if !capacity.isEqual(nil) {
                elements.setObject(capacity, forKey: CwnuTag.BEST_FOOD_CAPACITY)
            }
            if !opentime.isEqual(nil) {
                elements.setObject(opentime, forKey: CwnuTag.BEST_FOOD_OPENTIME)
            }
            if !deilvery.isEqual(nil) {
                elements.setObject(deilvery, forKey: CwnuTag.BEST_FOOD_DEILVERY)
            }
            if !goodcount.isEqual(nil) {
                elements.setObject(goodcount, forKey: CwnuTag.BEST_FOOD_GOOD_COUNT)
            }
            if !location.isEqual(nil) {
                elements.setObject(location, forKey: CwnuTag.BEST_FOOD_LOCATION)
            }
            if !lat.isEqual(nil) {
                elements.setObject(lat, forKey: CwnuTag.BEST_FOOD_LAT)
            }
            if !long.isEqual(nil) {
                elements.setObject(long, forKey: CwnuTag.BEST_FOOD_LNG)
            }
            
            posts.addObject(elements)
            
            
        }
        
    }
    @objc func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString(CwnuTag.BEST_FOOD_ID){
            id.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_NAME){
            name.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_PHONE){
            phone.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_INNER_IMAGE){
            innerimagepath.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_MENU_IMAGE){
            menuimagepath.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_OUTDOOR_IMAGE){
            outdoorimagepath.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_TYPE){
            type.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_CONTEXT){
            context.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_CAPACITY){
            capacity.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_OPENTIME){
            opentime.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_DEILVERY){
            deilvery.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_GOOD_COUNT){
            goodcount.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_LOCATION){
            location.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_LAT){
            lat.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.BEST_FOOD_LNG){
            long.appendString(replaceSpecialChar(string))
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

