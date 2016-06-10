//
//  CircleViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 15..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit
//import Google
class CircleViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "(아이폰)동아리정보")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "http://cwnuclub.alltheway.kr"
        let requestURL = NSURL(string: url)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
        
    }
    @IBAction func actBack(sender: AnyObject) {
        if webView.canGoBack {
            webView.goBack()
        }else {
            self.navigationController?.popViewControllerAnimated(true)
        }   
    }
}
