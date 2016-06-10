//
//  WagleDetailViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 5. 9..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

class WagleDetailViewController : UIViewController {
    
    @IBOutlet var wagleWebView: UIWebView!
    
    @IBOutlet var titleLb: UILabel!
    var type : String = ""
    var boardId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //와글공지
        var url = ""
        switch type {
        case "One":
            url = "http://portal.changwon.ac.kr/portalMain/mainonHomePostRead.do?homecd=&bno=1507&postno="+boardId
            break
        case "Two":
            url = "http://portal.changwon.ac.kr/homePost/read.do?homecd=portal&bno=3305&postno="+boardId.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            break
        case "Three":
            url = "http://portal.changwon.ac.kr/homePost/read.do?homecd=portal&bno=1291&postno="+boardId.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            break
        case "Four":
            url = "http://portal.changwon.ac.kr/homePost/read.do?homecd=portal&bno=1293&postno="+boardId.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            break
        case "MainNotice":
            titleLb.text = "공지사항"
            url = boardId.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            print(url)
            break
        default:
            break
        }
        let requestURL = NSURL(string: url)
        let request = NSURLRequest(URL: requestURL!)
        wagleWebView.scalesPageToFit = true
        wagleWebView.loadRequest(request)
        print(boardId)
    }
    
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
