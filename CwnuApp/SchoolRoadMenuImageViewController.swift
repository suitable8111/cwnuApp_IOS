//
//  SchoolRoadMenuImageViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 15..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

class SchoolRoadMenuImageViewController : UIViewController {
    
    var menuUrl : String?
    @IBOutlet var menuImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuImg.downloadedFrom(link: menuUrl!, contentMode: UIViewContentMode.ScaleAspectFit)
    }
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
