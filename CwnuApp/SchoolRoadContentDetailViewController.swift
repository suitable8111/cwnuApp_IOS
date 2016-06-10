
//
//  SchoolRoadContentDetailViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 14..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

class SchoolRoadContentDetailViewController: UIViewController {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var openTimeLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var capacityLabel: UILabel!
    @IBOutlet var contextLabel: UITextView!
    @IBOutlet var titleLabel: UILabel!
    
    var srcDic = NSDictionary()
    
    override func viewDidLoad() {
        let type = srcDic.valueForKey(CwnuTag.BEST_FOOD_TYPE) as! String
        
        switch type {
        case "CAFETERIA":
            self.categoryLabel.text = "식당"
            break
        case "DELIVERY":
            self.categoryLabel.text = "배달"
            break
        case "COFFEE":
            self.categoryLabel.text = "커피"
            break
        case "BAR":
            self.categoryLabel.text = "주점"
            break
        default:
            break
        }
        self.titleLabel.text = srcDic.valueForKey(CwnuTag.BEST_FOOD_NAME) as? String
        self.openTimeLabel.text = srcDic.valueForKey(CwnuTag.BEST_FOOD_OPENTIME) as? String
        self.phoneLabel.text = srcDic.valueForKey(CwnuTag.BEST_FOOD_PHONE) as? String
        self.capacityLabel.text = srcDic.valueForKey(CwnuTag.BEST_FOOD_CAPACITY) as? String
        self.contextLabel.text = srcDic.valueForKey(CwnuTag.BEST_FOOD_CONTEXT) as? String
        
        imgView.downloadedFrom(link: srcDic.valueForKey(CwnuTag.BEST_FOOD_INNER_IMAGE) as! String, contentMode: UIViewContentMode.ScaleAspectFit)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SchoolRoadMenuImage" {
            let sriControl = segue.destinationViewController as! SchoolRoadMenuImageViewController
            sriControl.menuUrl = srcDic.valueForKey(CwnuTag.BEST_FOOD_MENU_IMAGE) as? String
        }
    }
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
