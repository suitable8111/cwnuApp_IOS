//
//  BusInfoDetailViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 12..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

//정류장의 버스 도착시간, 남은 정류장, 버스번호를 알려주는 DetailView
class BusInfoDetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var stationNum : String = ""
    var stationName : String = ""
    var stationDetail : String = ""
    var busInfoDetailDataModel : BusInfoDetailDataModel?
    var fllteredBusInfo : NSMutableArray?
    
    @IBOutlet var stationNameLabel: UILabel!
    @IBOutlet var tbView: UITableView!
    
    func busInfoDetailDataModelInit () -> BusInfoDetailDataModel! {
        
        if busInfoDetailDataModel == nil {
            busInfoDetailDataModel = BusInfoDetailDataModel()
        }
        return busInfoDetailDataModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationNameLabel.text = stationName
        busInfoDetailDataModelInit ()
        busInfoDetailDataModel?.beginParsing(stationNum)
        if busInfoDetailDataModel?.posts.count != 0 {
            removeLeftTimeZero();
        }
        
        
        self.tbView.dataSource = self
        self.tbView.delegate = self
    }
    func removeLeftTimeZero() {
        fllteredBusInfo = NSMutableArray()
        for indexItem in (busInfoDetailDataModel?.posts)! {
            if (indexItem.valueForKey(CwnuTag.TRAFFIC_BUS_DETAIL_LEFT_TIME) as! String) != "0" {
                //busInfoDetailDataModel?.posts.removeObjectAtIndex(indexNum)
                fllteredBusInfo?.addObject(indexItem)
            }
        }
    }
    
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCellWithIdentifier("BusInfoDetailCell", forIndexPath: indexPath) as! BusInfoDetailTableViewCell
//        if busInfoDetailDataModel?.posts.count != 0 {
//        let busName : NSString = (busInfoDetailDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.TRAFFIC_BUS_DETAIL_NUM) as? NSString)!
//            cell.busName.text = busName.substringWithRange(NSRange(location: 5, length: 3)) + "번 버스"
//            cell.leftMinute.text = (busInfoDetailDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.TRAFFIC_BUS_DETAIL_LEFT_TIME) as? String)! + "분 남음"
//            cell.leftStation.text = (busInfoDetailDataModel?.posts.objectAtIndex(indexPath.row).valueForKey(CwnuTag.TRAFFIC_BUS_DETAIL_LEFT_STATION) as? String)! + "정거장 남음"
//        }
        
        if fllteredBusInfo?.count != 0 {
            let busName : NSString = (fllteredBusInfo?.objectAtIndex(indexPath.row).valueForKey(CwnuTag.TRAFFIC_BUS_DETAIL_NUM) as? NSString)!
            cell.busName.text = busName.substringWithRange(NSRange(location: 5, length: 3)) + "번 버스"
            cell.leftMinute.text = (fllteredBusInfo?.objectAtIndex(indexPath.row).valueForKey(CwnuTag.TRAFFIC_BUS_DETAIL_LEFT_TIME) as? String)! + "분 남음"
            cell.leftStation.text = (fllteredBusInfo?.objectAtIndex(indexPath.row).valueForKey(CwnuTag.TRAFFIC_BUS_DETAIL_LEFT_STATION) as? String)! + "정거장 남음"
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (busInfoDetailDataModel?.posts.count)!
        return (fllteredBusInfo?.count)!
    }
}

class BusInfoDetailDataModel: NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var element = NSString()
    var elements = NSMutableDictionary()
    
    private var busNum = NSMutableString()
    private var leftTime = NSMutableString()
    private var leftStation = NSMutableString()
    
    
    
    
    func beginParsing(staionNum : String){
        
        var stringURL = "http://cinavro12.cafe24.com/cwnu/traffic/traffic_service.php?stationNum=" + staionNum
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
            busNum = NSMutableString()
            busNum = ""
            leftTime = NSMutableString()
            leftTime = ""
            leftStation = NSMutableString()
            leftStation = ""
        }
    }
    @objc func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString(CwnuTag.BOARD_ROW) {
            
            if !busNum.isEqual(nil) {
                elements.setObject(busNum, forKey: CwnuTag.TRAFFIC_BUS_DETAIL_NUM)
            }
            if !leftTime.isEqual(nil) {
                elements.setObject(leftTime, forKey: CwnuTag.TRAFFIC_BUS_DETAIL_LEFT_TIME)
            }
            if !leftStation.isEqual(nil) {
                elements.setObject(leftStation, forKey: CwnuTag.TRAFFIC_BUS_DETAIL_LEFT_STATION)
            }
            
            posts.addObject(elements)
            
            
        }
        
    }
    @objc func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString(CwnuTag.TRAFFIC_BUS_DETAIL_NUM){
            busNum.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.TRAFFIC_BUS_DETAIL_LEFT_TIME){
            leftTime.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString(CwnuTag.TRAFFIC_BUS_DETAIL_LEFT_STATION){
            leftStation.appendString(replaceSpecialChar(string))
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
