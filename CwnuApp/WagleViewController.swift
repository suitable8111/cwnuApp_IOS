//
//  NoticeViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 29..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit
import Kanna
//import Google

class WagleViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var statusBar: UIView!
    @IBOutlet var wagleScroll: UIScrollView!
    
    @IBOutlet var loadingView: UIView!
    
    @IBOutlet var tbOne: UITableView!
    @IBOutlet var tbTwo: UITableView!
    @IBOutlet var tbThree: UITableView!
    @IBOutlet var tbFour: UITableView!
    
    var allAryOne : NSMutableArray?
    var allAryTwo : NSMutableArray?
    var allAryThree : NSMutableArray?
    var allAryFour : NSMutableArray?
    
    var currpageOne = 1
    var currpageTwo = 1
    var currpageThree = 1
    var currpageFour = 1
    
    var isReload : Bool = false
    var isActMoveStatus : Bool = false
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "(아이폰)와글공지")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidLoad() {
        
        wagleScroll.delegate = self
        self.tbOne.delegate = self
        self.tbTwo.delegate = self
        self.tbThree.delegate = self
        self.tbFour.delegate = self
        
        self.tbOne.dataSource = self
        self.tbTwo.dataSource = self
        self.tbThree.dataSource = self
        self.tbFour.dataSource = self
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

        dispatch_async(queue, {() -> () in
            self.allAryOne = self.parserHTML(0,currPage: self.currpageOne)
            self.allAryTwo = self.parserHTML(1,currPage: self.currpageTwo)
            self.allAryThree = self.parserHTML(2,currPage: self.currpageThree)
            self.allAryFour = self.parserHTML(3,currPage: self.currpageFour)
            dispatch_async(dispatch_get_main_queue(), { () -> () in
                self.tbOne.reloadData()
                self.tbTwo.reloadData()
                self.tbThree.reloadData()
                self.tbFour.reloadData()
                self.loadingView.hidden = true
            })
        })
        
    }
    
    //TABLE VIEW DELEGATE
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tbOne:
            if allAryOne == nil {
                return 0
            }else {
                return (allAryOne?.count)!
            }
        case self.tbTwo:
            if allAryTwo == nil {
                return 0
            }else {
                return (allAryTwo?.count)!
            }
        case self.tbThree:
            if allAryThree == nil {
                return 0
            }else {
                return (allAryThree?.count)!
            }
        case self.tbFour:
            if allAryFour == nil {
                return 0
            }else {
                return (allAryFour?.count)!
            }
        default:
            return 1
        }
        
    }
    
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        
        switch tableView {
        case self.tbOne:
            cell = tbOne.dequeueReusableCellWithIdentifier("WagleCell", forIndexPath: indexPath) as UITableViewCell
            break
        case self.tbTwo:
            cell = tbTwo.dequeueReusableCellWithIdentifier("WagleCell", forIndexPath: indexPath) as UITableViewCell
            break
        case self.tbThree:
            cell = tbThree.dequeueReusableCellWithIdentifier("WagleCell", forIndexPath: indexPath) as UITableViewCell
            break
        case self.tbFour:
            cell = tbFour.dequeueReusableCellWithIdentifier("WagleCell", forIndexPath: indexPath) as UITableViewCell
            break
        default:
            break
        }
        
        let titleLbl = cell!.viewWithTag(5001) as! UILabel
        let dateLbl = cell!.viewWithTag(5002) as! UILabel
        let nameLbl = cell!.viewWithTag(5003) as! UILabel
        
        switch tableView {
        case self.tbOne:
            titleLbl.text = allAryOne!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_TITLE) as? String
            dateLbl.text = allAryOne!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_DATE) as? String
            nameLbl.text = allAryOne!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_NAME) as? String
            break
        case self.tbTwo:
            titleLbl.text = allAryTwo!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_TITLE) as? String
            dateLbl.text = allAryTwo!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_DATE) as? String
            nameLbl.text = allAryTwo!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_NAME) as? String
            break
        case self.tbThree:
            titleLbl.text = allAryThree!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_TITLE) as? String
            dateLbl.text = allAryThree!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_DATE) as? String
            nameLbl.text = allAryThree!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_NAME) as? String
            break
        case self.tbFour:
            titleLbl.text = allAryFour!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_TITLE) as? String
            dateLbl.text = allAryFour!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_DATE) as? String
            nameLbl.text = allAryFour!.objectAtIndex(indexPath.row).valueForKey(CwnuTag.WAGLE_NAME) as? String
            break
        default:
            break
        }
        if indexPath.row % 2 == 0 {
            cell!.backgroundColor = UIColor.whiteColor()
        }else {
            cell!.backgroundColor = UIColor(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1.0)
        }
        return cell!
    }
    //
    
    //값 전달
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let wgDControl = segue.destinationViewController as! WagleDetailViewController
        switch segue.identifier! {
        case "WagleOne":
            wgDControl.boardId = (allAryOne?.objectAtIndex((tbOne.indexPathForSelectedRow?.row)!).valueForKey(CwnuTag.WAGLE_ID) as? String)!
            wgDControl.type = "One"
            break
        case "WagleTwo":
            wgDControl.boardId = (allAryTwo?.objectAtIndex((tbTwo.indexPathForSelectedRow?.row)!).valueForKey(CwnuTag.WAGLE_ID) as? String)!
            wgDControl.type = "Two"
            break
        case "WagleThree":
            wgDControl.boardId = (allAryThree?.objectAtIndex((tbThree.indexPathForSelectedRow?.row)!).valueForKey(CwnuTag.WAGLE_ID) as? String)!
            wgDControl.type = "Three"
            break
        case "WagleFour":
            wgDControl.boardId = (allAryFour?.objectAtIndex((tbFour.indexPathForSelectedRow?.row)!).valueForKey(CwnuTag.WAGLE_ID) as? String)!
            wgDControl.type = "Four"
            break
        default :
            break
        }
        
    }
    
    //
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func actOne(sender: AnyObject) {
        self.anmateSelectedBar(0)
    }
    @IBAction func actTwo(sender: AnyObject) {
        self.anmateSelectedBar(1)
    }
    @IBAction func actThree(sender: AnyObject) {
        self.anmateSelectedBar(2)
    }
    @IBAction func actFour(sender: AnyObject) {
        self.anmateSelectedBar(3)
    }
    //selected 애니메이션 구현
    func anmateSelectedBar(index : Int) {
        isActMoveStatus = true
        UIView.animateWithDuration(0.5, animations: {
                self.statusBar.transform = CGAffineTransformMakeTranslation(self.statusBar.frame.width*CGFloat(index), 0);
            }, completion: {finished in
                self.isActMoveStatus = false
            })
        let frame = self.wagleScroll.frame
        let scrollPoint = CGPointMake(frame.size.width*CGFloat(index), 0.0)
        self.wagleScroll.setContentOffset(scrollPoint, animated: true)
    }
    
    func parserHTML(index : Int, currPage : Int) -> NSMutableArray {
        var allAry : NSMutableArray!
        var allDic : NSMutableDictionary!
        
        var apiURI : NSURL?
        //와글공지
        if index == 0 {
            apiURI = NSURL(string: "http://portal.changwon.ac.kr/portalMain/mainonHomePostList.do?currPage="+String(currPage))
        }else if index == 1 {
        //학사안내
            apiURI = NSURL(string: "http://portal.changwon.ac.kr/homePost/list.do?common=portal&homecd=portal&bno=3305&currPage="+String(currPage))
        }else if index == 2 {
        //공지사항
            apiURI = NSURL(string: "http://portal.changwon.ac.kr/homePost/list.do?common=portal&homecd=portal&bno=1291&currPage="+String(currPage))
        }else if index == 3 {
        //모집안내
            apiURI = NSURL(string: "http://portal.changwon.ac.kr/homePost/list.do?common=portal&homecd=portal&bno=1293&currPage="+String(currPage))
        }
        
        
        allAry = NSMutableArray()
        
        var count = 0
        
        let apidata : NSData? = NSData(contentsOfURL: apiURI!)
        if let doc = Kanna.HTML(html: apidata!, encoding: NSUTF8StringEncoding) {
//            print(doc.title)
            
//            // Search for nodes by CSS
//            for link in doc.css("a, link") {
//                print(link.text)
//                print(link["href"])
//            }
            
            // Search for nodes by XPath
//            for link in doc.xpath("//a | //link") {
//                print(link.text)
//                print(link["td"])
//            }
            
            var isNotice = false
            
            for link in doc.xpath("//td") {
                
                
                
                let tdText = link.text!.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                
                if index == 1 || index == 0 {
                    let temp = count % 5
                    if temp == 0 {
                        allDic = NSMutableDictionary()
                        if tdText.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)==""{
                            isNotice = true
                            //이녀석은 공지 입니다.
                        } else {
                            allDic?.setObject(tdText.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), forKey: CwnuTag.WAGLE_ID)
                        }
                    }else if temp == 1 {
                        if isNotice == true{
                            //공지니깐 a herf 가져갈께요
                            let rangeText = link.innerHTML
                            let range : Range<String.Index> = rangeText!.rangeOfString("postno=")!
                            let range2 : Range<String.Index> = rangeText!.rangeOfString("amp;currPage=")!
                            
                            let startIndex: Int = rangeText!.startIndex.distanceTo(range.endIndex)
                            let endIndex: Int = rangeText!.startIndex.distanceTo(range2.startIndex)
                            
                            
                            let noticeId : NSString = link.innerHTML! as NSString
                            
//                            print(postTime.substringWithRange(NSRange(location: startIndex, length: endIndex-startIndex-1)))
                            
//                            print(startIndex)
//                            print(endIndex)
                            allDic?.setObject(noticeId.substringWithRange(NSRange(location: startIndex, length: endIndex-startIndex-1)), forKey: CwnuTag.WAGLE_ID)
                            isNotice = false
                        }else {
                            
                        }
                        allDic?.setObject(tdText.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), forKey: CwnuTag.WAGLE_TITLE)
                    }else if temp == 2 {
                        allDic?.setObject(tdText.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), forKey: CwnuTag.WAGLE_NAME)
                    }else if temp == 3 {
                        allDic?.setObject(tdText.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), forKey: CwnuTag.WAGLE_DATE)
                    }else if temp == 4 {
                        allDic?.setObject(tdText.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), forKey: CwnuTag.WAGLE_VIEW_COUNT)
                        allAry?.addObject(allDic!)
                    }
                }else if index == 2 || index == 3{
                    let temp = count % 4
                    if temp == 0 {
                        allDic = NSMutableDictionary()
                        allDic?.setObject(tdText.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), forKey: CwnuTag.WAGLE_ID)
                    }else if temp == 1 {
                        allDic?.setObject(tdText.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), forKey: CwnuTag.WAGLE_TITLE)
                    }else if temp == 2 {
                        allDic?.setObject(tdText.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), forKey: CwnuTag.WAGLE_DATE)
                    }else if temp == 3 {
                        allDic?.setObject(tdText.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), forKey: CwnuTag.WAGLE_VIEW_COUNT)
                        allDic?.setObject("창원대학교", forKey: CwnuTag.WAGLE_NAME)
                        allAry?.addObject(allDic!)
                    }
                }
                //print(link.text!.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
                count += 1
            }

        }
        if index == 0 {
            //self.tbOne.reloadData()
            print("done1")
        }else if index == 1 {
            //학사안내
            //self.tbTwo.reloadData()
            print("done2")
        }else if index == 2 {
            //공지사항
            //self.tbThree.reloadData()
            print("done3")
        }else if index == 3 {
            //모집안내
            //self.tbFour.reloadData()
            print("done4")
        }
        
        return allAry
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        switch scrollView {
        case wagleScroll:
            if isActMoveStatus == false {
                let indexPage = wagleScroll.contentOffset.x / scrollView.frame.width
                self.statusBar.frame.origin.x = self.statusBar.frame.width*CGFloat(indexPage)
            }
        case tbOne:
            let offset : CGPoint = tbOne.contentOffset
            let bounds : CGRect = tbOne.bounds
            let size : CGSize = tbOne.contentSize
            let inset : UIEdgeInsets = tbOne.contentInset
            
            let y : CGFloat = offset.y + bounds.size.height - inset.bottom
            let h : CGFloat = size.height
            
            let nextValue : CGFloat = 10
            if (y > h + nextValue) {
                self.isReload = true
                reloadData(0)
            }
            break
        case tbTwo:
            let offset : CGPoint = tbTwo.contentOffset
            let bounds : CGRect = tbTwo.bounds
            let size : CGSize = tbTwo.contentSize
            let inset : UIEdgeInsets = tbTwo.contentInset
            
            let y : CGFloat = offset.y + bounds.size.height - inset.bottom
            let h : CGFloat = size.height
            
            let nextValue : CGFloat = 10
            if (y > h + nextValue) {
                self.isReload = true
                reloadData(1)
            }
            break
        case tbThree:
            let offset : CGPoint = tbThree.contentOffset
            let bounds : CGRect = tbThree.bounds
            let size : CGSize = tbThree.contentSize
            let inset : UIEdgeInsets = tbThree.contentInset
            
            let y : CGFloat = offset.y + bounds.size.height - inset.bottom
            let h : CGFloat = size.height
            
            let nextValue : CGFloat = 10
            if (y > h + nextValue) {
                self.isReload = true
                reloadData(2)
            }
            break
        case tbFour:
            let offset : CGPoint = tbFour.contentOffset
            let bounds : CGRect = tbFour.bounds
            let size : CGSize = tbFour.contentSize
            let inset : UIEdgeInsets = tbFour.contentInset
            
            let y : CGFloat = offset.y + bounds.size.height - inset.bottom
            let h : CGFloat = size.height
            
            let nextValue : CGFloat = 10
            if (y > h + nextValue) {
                self.isReload = true
                reloadData(3)
            }
            break
        default:
            break
        }
        
    }
    func reloadData(value : Int) {
        if self.isReload == true {
            switch value {
            case 0:
                currpageOne += 1
                print(currpageOne)
                allAryOne?.addObjectsFromArray(self.parserHTML(0,currPage: currpageOne) as [AnyObject])
                tbOne.reloadData()
                self.isReload = false
                break
            case 1:
                currpageTwo += 1
                print(currpageTwo)
                allAryTwo?.addObjectsFromArray(self.parserHTML(1,currPage: currpageTwo) as [AnyObject])
                tbTwo.reloadData()
                self.isReload = false
                break
            case 2:
                currpageThree += 1
                print(currpageThree)
                allAryThree?.addObjectsFromArray(self.parserHTML(2,currPage: currpageThree) as [AnyObject])
                tbThree.reloadData()
                self.isReload = false
                break
            case 3:
                currpageFour += 1
                print(currpageFour)
                allAryFour?.addObjectsFromArray(self.parserHTML(3,currPage: currpageFour) as [AnyObject])
                tbFour.reloadData()
                self.isReload = false
                break
            default:
                break
            }
            
        }
    }
}