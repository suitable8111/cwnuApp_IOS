//
//  MapInfoController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 3. 5..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
//import Google

//학과 지도 API를 받아와 지도로 뿌려주는 ViewController

class MapInfoController : UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    //애플맵뷰
    @IBOutlet var mapView: MKMapView!
    //위로 스윽 올라오는 뷰
    @IBOutlet var controlView: UIView!
    //테이블 뷰
    @IBOutlet var tbView: UITableView!
    //검색 텍스트필드
    @IBOutlet var searchingTextField: UITextField!
    
    //annotations
    var annotations = [MKPointAnnotation()]
    //좌표 데이터 모델
    var coordataModel : CoorDataModel!
    //건물 검색 데이터 모델
    var mapsearchDataModel : MapSearchDataModel!
    var isSearching = false
    
    func initdataModel() -> (CoorDataModel, MapSearchDataModel) {
        if(coordataModel==nil && mapsearchDataModel==nil){
            coordataModel = CoorDataModel()
            mapsearchDataModel = MapSearchDataModel()
        }
        
        return (coordataModel, mapsearchDataModel)
    }
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "(아이폰)학교지도")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initdataModel()
        coordataModel.beginParsing()
        
        makeMapView()
        animateTable()
        mapView.delegate = self
        tbView.dataSource = self
        tbView.delegate = self
        searchingTextField.delegate = self
        controlView.frame.size = CGSizeMake(controlView.frame.width, controlView.frame.height * self.view.frame.height / 600)
    }
    //테이블뷰 애니메이션
    func animateTV(){
        if isSearching {
            UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                
                self.controlView.transform = CGAffineTransformMakeTranslation(0, -300)
                
                }, completion: nil)
        }else {
            UIView.animateWithDuration(3.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                
                self.controlView.transform = CGAffineTransformMakeTranslation(0, 300)
                
                }, completion: nil)
        }

    }
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        mapsearchDataModel.beginParsing("BUILDING", searchText: (view.annotation?.subtitle!)!)
        isSearching = true
        animateTV()
        animateTable()
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil
        {
            let imageName = "mark"+annotation.subtitle!!+".png"
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: imageName)
            annotationView!.rightCalloutAccessoryView = detailButton
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if isSearching {
            isSearching = false
            animateTV()
        }
    }
    //지도 생성 함수
    func makeMapView(){
        
        var location = CLLocationCoordinate2D()
        
        var lat = coordataModel.posts.objectAtIndex(0).valueForKey("lat") as? String
        var lng = coordataModel.posts.objectAtIndex(0).valueForKey("lng") as? String
        
        location.latitude = NSString(string: lat!).doubleValue
        location.longitude = NSString(string: lng!).doubleValue
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        self.annotations = [MKPointAnnotation()]
        self.mapView.setRegion(region, animated: true)
        
        for i in 0 ..< coordataModel.posts.count {
            lat = coordataModel.posts.objectAtIndex(i).valueForKey("lat") as? String
            lng = coordataModel.posts.objectAtIndex(i).valueForKey("lng") as? String
            
            location.latitude = NSString(string: lat!).doubleValue
            location.longitude = NSString(string: lng!).doubleValue
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = coordataModel.posts.objectAtIndex(i).valueForKey("structure_name") as? String
            annotation.subtitle = coordataModel.posts.objectAtIndex(i).valueForKey("structure_num") as? String
            
            self.annotations.append(annotation)
            //mapView.addAnnotation(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    
    //TABELVIEW Delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCellWithIdentifier("MapInfoCell", forIndexPath: indexPath) as UITableViewCell
        
        let titleLabel = cell.viewWithTag(101) as! UILabel
        let floorLabel = cell.viewWithTag(102) as! UILabel
        
        if (mapsearchDataModel.posts.count != 0) {
            titleLabel.text = mapsearchDataModel.posts.objectAtIndex(indexPath.row).valueForKey(("room_name")) as? String
            floorLabel.text = (mapsearchDataModel.posts.objectAtIndex(indexPath.row).valueForKey(("floor_num")) as? String)! + "층"
        }
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.whiteColor()
        }else {
            cell.backgroundColor = UIColor(red: 230.0/255, green: 231.0/255, blue: 232.0/255, alpha: 1.0)
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (mapsearchDataModel.posts.count != 0) {
            return mapsearchDataModel.posts.count;
        }else{
            return 0;
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (mapsearchDataModel.posts.count != 0) {
            print(mapsearchDataModel.posts.objectAtIndex(indexPath.row).valueForKey("building_num") as! String)
            
            
            let selectData = (mapsearchDataModel.posts.objectAtIndex(indexPath.row).valueForKey("building_num") as? String)!
            
            for i in 0 ..< coordataModel.posts.count {
                let structData = (coordataModel.posts.objectAtIndex(i).valueForKey("structure_num") as? String)!
                if structData == selectData {
                    self.mapView.selectAnnotation(annotations[i+1], animated: true)
                    
                    let location = annotations[i+1].coordinate
                    let span = MKCoordinateSpanMake(0.01, 0.01)
                    
                    let region = MKCoordinateRegion(center: location, span: span)
                    mapView.setRegion(region, animated: true)
                    
                    
                }
            }
        }else{
            
        }
    }
    func animateTable(){
        tbView.reloadData()
        let cells = tbView.visibleCells
        let tableHeight : CGFloat = tbView.bounds.size.height
        
        for i in cells {
            let cell : UITableViewCell = i
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a
            UIView.animateWithDuration(1.0, delay: 0.02 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }

    
    
    //TEXTFIELD Delegate

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let searchText = searchingTextField.text! as String
        mapsearchDataModel.beginParsing("SEARCH", searchText: searchText)
        textField.resignFirstResponder()
        isSearching = true
        animateTV()
        animateTable()
        return true
    }
    
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}






///DATA MODEL!
class CoorDataModel: NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var element = NSString()
    var elements = NSMutableDictionary()
    
    var lat = NSMutableString()
    var lng = NSMutableString()
    var structure_num = NSMutableString()
    var structure_name = NSMutableString()

    
    
    func beginParsing(){
        
        var stringURL : String = ""
        stringURL = "http://cinavro12.cafe24.com/cwnu/mapinfo/cwnu_coord_xml.php"
        
        let url = NSURL(string: stringURL)
        
        parser = NSXMLParser(contentsOfURL: url!)!
        parser.delegate = self
        parser.parse()
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
        if(elementName as NSString).isEqualToString("row"){
            elements = NSMutableDictionary()
            elements = [:]
            lat = NSMutableString()
            lat = ""
            lng = NSMutableString()
            lng = ""
            structure_num = NSMutableString()
            structure_num = ""
            structure_name = NSMutableString()
            structure_name = ""
            
        }
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("row") {
            
            if !lat.isEqual(nil) {
                elements.setObject(lat, forKey: "lat")
            }
            if !lng.isEqual(nil) {
                elements.setObject(lng, forKey: "lng")
            }
            if !structure_num.isEqual(nil) {
                elements.setObject(structure_num, forKey: "structure_num")
            }
            if !structure_name.isEqual(nil) {
                elements.setObject(structure_name, forKey: "structure_name")
            }
            posts.addObject(elements)
            
            
        }
        
    }
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("lat"){
            lat.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString("lng"){
            lng.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString("structure_num"){
            structure_num.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString("structure_name"){
            structure_name.appendString(replaceSpecialChar(string))
        }
    }
    func replaceSpecialChar(str:String) -> String{
        let str_change = NSMutableString(string: str)
        
        str_change.replaceOccurrencesOfString("\n\t\t\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        return str_change as String
    }
}
class MapSearchDataModel: NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var element = NSString()
    var elements = NSMutableDictionary()
    
    var building_num = NSMutableString()
    var room_name = NSMutableString()
    var floor_num = NSMutableString()
    
    
    
    func beginParsing(category : String, searchText : String){
        posts.removeAllObjects()
        var stringURL = ""
        if category=="BUILDING"{
            stringURL = "http://chains.changwon.ac.kr/nonstop/building_info/building_info.php?id="+searchText
        }else if category=="SEARCH" {
            stringURL = "http://chains.changwon.ac.kr/nonstop/building_info/building_info.php?dept="+searchText
        }
        
        let s = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy()
        s.addCharactersInString("+&")
        stringURL = stringURL.stringByAddingPercentEncodingWithAllowedCharacters(s as! NSCharacterSet)!;
        let url = NSURL(string: stringURL)
        
        parser = NSXMLParser(contentsOfURL: url!)!
        parser.delegate = self
        parser.parse()
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
        if(elementName as NSString).isEqualToString("building"){
            elements = NSMutableDictionary()
            elements = [:]
            building_num = NSMutableString()
            building_num = ""
            room_name = NSMutableString()
            room_name = ""
            floor_num = NSMutableString()
            floor_num = ""
            
        }
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("building") {
            
            if !building_num.isEqual(nil) {
                elements.setObject(building_num, forKey: "building_num")
            }
            if !room_name.isEqual(nil) {
                elements.setObject(room_name, forKey: "room_name")
            }
            if !floor_num.isEqual(nil) {
                elements.setObject(floor_num, forKey: "floor_num")
            }
            posts.addObject(elements)
            
        }
        
    }
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString("building_num"){
            building_num.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString("room_name"){
            room_name.appendString(replaceSpecialChar(string))
        }else if element.isEqualToString("floor_num"){
            floor_num.appendString(replaceSpecialChar(string))
        }
    }
    func replaceSpecialChar(str:String) -> String{
        let str_change = NSMutableString(string: str)
    
        str_change.replaceOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, str_change.length))
        return str_change as String
    }
    
}