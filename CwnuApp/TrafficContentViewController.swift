//
//  TrafficContentViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 11..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

//인덱스 값을 받아와 서버에 저장된 url에 접속한다.

class TrafficContentViewController : UIViewController {
    
    var pageIndex : Int?
    
    
    @IBOutlet var trafficWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pageIndex == 1 {
            let url = "http://cinavro12.cafe24.com/cwnu/schoolbus/"
            let requestURL = NSURL(string: url)
            let request = NSURLRequest(URL: requestURL!)
            trafficWebView.loadRequest(request)
        }else {
            
        }
    }
}
