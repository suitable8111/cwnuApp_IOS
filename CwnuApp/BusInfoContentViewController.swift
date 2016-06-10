//
//  BusInfoContentViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 11..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit


//학교 주변 버스 정류장을 담아주는 ContentViewController
class BusInfoContentViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pageIndex : Int?
    var busArray : NSMutableArray?
    
    @IBOutlet var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        busArray = NSMutableArray()
        
        var busDic = NSMutableDictionary()
        busDic.setObject("379002287", forKey: CwnuTag.TRAFFIC_BUS_NUM)
        busDic.setObject("우영프라자", forKey: CwnuTag.TRAFFIC_BUS_NAME)
        busDic.setObject(">>우영프라자 맞은편 야구장 쪽", forKey: CwnuTag.TRAFFIC_BUS_DETAIL)
        busArray?.addObject(busDic)
        busDic = NSMutableDictionary()
        busDic.setObject("379000621", forKey: CwnuTag.TRAFFIC_BUS_NUM)
        busDic.setObject("우영프라자", forKey: CwnuTag.TRAFFIC_BUS_NAME)
        busDic.setObject(">>우영프라자 입구 쪽", forKey: CwnuTag.TRAFFIC_BUS_DETAIL)
        busArray?.addObject(busDic)
        busDic = NSMutableDictionary()
        busDic.setObject("379000610", forKey: CwnuTag.TRAFFIC_BUS_NUM)
        busDic.setObject("창원대학교입구", forKey: CwnuTag.TRAFFIC_BUS_NAME)
        busDic.setObject(">>롯데리아, GS25", forKey: CwnuTag.TRAFFIC_BUS_DETAIL)
        busArray?.addObject(busDic)
        busDic = NSMutableDictionary()
        busDic.setObject("379002287", forKey: CwnuTag.TRAFFIC_BUS_NUM)
        busDic.setObject("창원대학교입구", forKey: CwnuTag.TRAFFIC_BUS_NAME)
        busDic.setObject(">>롯데리아, GS25 맞은편", forKey: CwnuTag.TRAFFIC_BUS_DETAIL)
        busArray?.addObject(busDic)
        busDic = NSMutableDictionary()
        busDic.setObject("379000591", forKey: CwnuTag.TRAFFIC_BUS_NUM)
        busDic.setObject("창원대학교 종점", forKey: CwnuTag.TRAFFIC_BUS_NAME)
        busDic.setObject(">>창원대학교 입구 쪽", forKey: CwnuTag.TRAFFIC_BUS_DETAIL)
        busArray?.addObject(busDic)
        busDic = NSMutableDictionary()
        busDic.setObject("379003357", forKey: CwnuTag.TRAFFIC_BUS_NUM)
        busDic.setObject("창원중앙역", forKey: CwnuTag.TRAFFIC_BUS_NAME)
        busDic.setObject(">>창원중앙역", forKey: CwnuTag.TRAFFIC_BUS_DETAIL)
        busArray?.addObject(busDic)
        busDic = NSMutableDictionary()
        busDic.setObject("379002786", forKey: CwnuTag.TRAFFIC_BUS_NUM)
        busDic.setObject("창원중부방순찰대", forKey: CwnuTag.TRAFFIC_BUS_NAME)
        busDic.setObject(">>창원중앙역에서 빠져나가는 쪽", forKey: CwnuTag.TRAFFIC_BUS_DETAIL)
        busArray?.addObject(busDic)
        
        tbView.dataSource = self
        tbView.delegate = self
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCellWithIdentifier("BusInfoCell", forIndexPath: indexPath) as! BusInfoTableViewCell
        
        cell.titleLabel.text = busArray?.objectAtIndex(indexPath.row).valueForKey(CwnuTag.TRAFFIC_BUS_NAME) as? String
        cell.detailLabel.text = busArray?.objectAtIndex(indexPath.row).valueForKey(CwnuTag.TRAFFIC_BUS_DETAIL) as? String
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (busArray?.count)!;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
        case "busDetail":
            let bdControl = segue.destinationViewController as! BusInfoDetailViewController
            bdControl.stationNum = (busArray?.objectAtIndex((self.tbView.indexPathForSelectedRow?.row)!).valueForKey(CwnuTag.TRAFFIC_BUS_NUM) as? String)!
            bdControl.stationName = (busArray?.objectAtIndex((self.tbView.indexPathForSelectedRow?.row)!).valueForKey(CwnuTag.TRAFFIC_BUS_NAME) as? String)!
            bdControl.stationDetail = (busArray?.objectAtIndex((self.tbView.indexPathForSelectedRow?.row)!).valueForKey(CwnuTag.TRAFFIC_BUS_DETAIL) as? String)!
    
            break
        default :
            break
        }
        
    }
}
