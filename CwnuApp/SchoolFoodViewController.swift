//
//  SchoolFoodViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 5. 6..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit
import Kanna


class SchoolFoodViewController: UIViewController, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var textSarimE: UITextView!
    @IBOutlet weak var textSarimD: UITextView!
    @IBOutlet weak var textSarimC: UITextView!
    @IBOutlet weak var textSarimB: UITextView!
    @IBOutlet weak var textSarimA: UITextView!
    
    @IBOutlet weak var textBongE: UITextView!
    @IBOutlet weak var textBongD: UITextView!
    @IBOutlet weak var textBongC: UITextView!
    @IBOutlet weak var textBongB: UITextView!
    @IBOutlet weak var textBongA: UITextView!
    
    @IBOutlet weak var textDomiG: UITextView!
    @IBOutlet weak var textDomiF: UITextView!
    @IBOutlet weak var textDomiE: UITextView!
    @IBOutlet weak var textDomiD: UITextView!
    @IBOutlet weak var textDomiC: UITextView!
    @IBOutlet weak var textDomiB: UITextView!
    @IBOutlet weak var textDomiA: UITextView!
    
    @IBOutlet var dormA: UIView!
    @IBOutlet var dormB: UIView!
    @IBOutlet var dormC: UIView!
    @IBOutlet var dormD: UIView!
    @IBOutlet var dormE: UIView!
    @IBOutlet var dormF: UIView!
    @IBOutlet var dormG: UIView!
    
    @IBOutlet var bongA: UIView!
    @IBOutlet var bongB: UIView!
    @IBOutlet var bongC: UIView!
    @IBOutlet var bongD: UIView!
    @IBOutlet var bongE: UIView!
    
    @IBOutlet var sarimA: UIView!
    @IBOutlet var sarimB: UIView!
    @IBOutlet var sarimC: UIView!
    @IBOutlet var sarimD: UIView!
    @IBOutlet var sarimE: UIView!
    
    @IBOutlet var statusBar: UIView!
    @IBOutlet var datePickerView: UIPickerView!
    @IBOutlet var selectedView: UIButton!
    @IBOutlet var titleLb: UILabel!
    
    var isActMoveStatus : Bool = false
    var sarim = [[String]]()        //사림관 메뉴 이중배열 [메뉴][요일]
    var bongrim = [[String]]()      //봉림관 메뉴 이중배열 [메뉴][요일]
    var dormitory = [[String]]()    //사림관 메뉴 이중배열 [요일][메뉴]
    
    let sarimStart = ["양식(11:30~14:30/17:00~18:30)\r\n    ", "한식(11:30~14:30/17:00~18:30)\r\n    ", "정식(11:30~14:30/17:00~18:30)\r\n    ", "분식(라면)(11:30~14:30/17:00~18:30)\r\n    "]
    //사림관 메뉴 찾기 시작
    let bongrimStart = ["동백홀(교직원식당)정식(11:20~14:00)\r\n    ", "동백홀(교직원식당)석식(17:00~18:30)\r\n    ", "(1층학생식당)중식(11:30~14:30)\r\n    ", "(1층학생식당)석식(17:00~18:30)\r\n    ", "분식(11:20~14:00/17:00~18:30)\r\n    "]
    //봉림관 메뉴 찾기 시작
    let dormitoriStart = ["opt01\" value=\"", "opt02\" value=\"", "opt03\" value=\"", "opt04\" value=\"", "opt05\" value=\"", "opt06\" value=\"", "opt07\" value=\""]
    //기숙사 요일 찾기 시작
    let sign = ["①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨", "⑩", "⑪", "⑫"]
    let datePicker = ["월요일","화요일","수요일","목요일","금요일","토요일","일요일"]
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "(아이폰)학교식단표")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.scroll.delegate = self
        self.datePickerView.delegate = self
        self.datePickerView.dataSource = self
        
        
        self.dormA.layer.cornerRadius = 12
        self.dormB.layer.cornerRadius = 12
        self.dormC.layer.cornerRadius = 12
        self.dormD.layer.cornerRadius = 12
        self.dormE.layer.cornerRadius = 12
        self.dormF.layer.cornerRadius = 12
        self.dormG.layer.cornerRadius = 12
        
        self.dormA.layer.masksToBounds = true
        self.dormB.layer.masksToBounds = true
        self.dormC.layer.masksToBounds = true
        self.dormD.layer.masksToBounds = true
        self.dormE.layer.masksToBounds = true
        self.dormF.layer.masksToBounds = true
        self.dormG.layer.masksToBounds = true
        
        
        self.bongA.layer.cornerRadius = 12
        self.bongB.layer.cornerRadius = 12
        self.bongC.layer.cornerRadius = 12
        self.bongD.layer.cornerRadius = 12
        self.bongE.layer.cornerRadius = 12
        
        self.bongA.layer.masksToBounds = true
        self.bongB.layer.masksToBounds = true
        self.bongC.layer.masksToBounds = true
        self.bongD.layer.masksToBounds = true
        self.bongE.layer.masksToBounds = true
        
        
        self.sarimA.layer.cornerRadius = 12
        self.sarimB.layer.cornerRadius = 12
        self.sarimC.layer.cornerRadius = 12
        self.sarimD.layer.cornerRadius = 12
        self.sarimE.layer.cornerRadius = 12
        
        self.sarimA.layer.masksToBounds = true
        self.sarimB.layer.masksToBounds = true
        self.sarimC.layer.masksToBounds = true
        self.sarimD.layer.masksToBounds = true
        self.sarimE.layer.masksToBounds = true
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(queue, {() -> () in
            self.parserData()
            
            dispatch_async(dispatch_get_main_queue(), { () -> () in
                self.settingDate()
            })
        })
        
    }
    func parserData() {
        let menuA = [String]()
        let menuB = [String]()
        let menuC = [String]()
        let menuD = [String]()
        let menuE = [String]()
        let menuF = [String]()
        let menuG = [String]()
        sarim = [menuA, menuB, menuC, menuD]
        bongrim = [menuA, menuB, menuC, menuD, menuE]
        dormitory = [menuA, menuB, menuC, menuD, menuE, menuF, menuG]
        var urlStr: String? //기숫사 주소 뒷부분
        //사림관 주소
        let apiURL = NSURL(string: "http://chains.changwon.ac.kr/wwwhome/html/mailbox/lunch.php?kind=S")
        let apiData : NSData = NSData(contentsOfURL: apiURL!)!
        //봉림관 주소
        let apiURLB = NSURL(string: "http://chains.changwon.ac.kr/wwwhome/html/mailbox/lunch.php?kind=B")
        let apiDataB = NSData(contentsOfURL: apiURLB!)!
        //기숙사 주소 찾기
        let apiURLX = NSURL(string: "http://portal.changwon.ac.kr/homePost/list.do?bno=2382")
        let apiDataX = NSData(contentsOfURL: apiURLX!)!
        
        //기숙사 주소 찾기
        if let docX = Kanna.HTML(html: apiDataX, encoding: NSUTF8StringEncoding) {
            
            let readStart = docX.text?.rangeOfString("self.location=\'")
            let readEnd = docX.text?.rangeOfString("\';")
            let start = readStart?.endIndex
            let end = readEnd?.startIndex
            
            urlStr = docX.text![start!..<end!]  //기숙사 주소 뒷부분
        }
        //기숙사 완전한 주소
        let apiURLC = NSURL(string: "http://portal.changwon.ac.kr/homePost/"+urlStr!)
        let apiDataC = NSData(contentsOfURL: apiURLC!)!
        //기숙사 파싱
        if let docDormi = Kanna.HTML(html: apiDataC, encoding: NSUTF8StringEncoding) {
            let article = docDormi.toHTML
            
            for j in 0..<dormitory.count    {           //요일 구분
                var menuStart = article!.rangeOfString(dormitoriStart[j], options: NSStringCompareOptions.LiteralSearch, range: (article!.startIndex)..<(article!.endIndex), locale: nil)
                
                for i in 0...9   {                      //메뉴 구분
                    var menuEnd: Range<String.Index>?
                    
                    if i != 9    {                      //'|' 구분
                        menuEnd = article!.rangeOfString("|", options: NSStringCompareOptions.LiteralSearch, range: (menuStart?.endIndex)!..<(article!.endIndex), locale: nil)
                    }   else    {                   //마지막은 '\'구분
                        menuEnd = article!.rangeOfString("\"", options: NSStringCompareOptions.LiteralSearch, range: (menuStart?.endIndex)!..<(article!.endIndex), locale: nil)
                    }
                    dormitory[j].append(article![(menuStart?.endIndex)!..<(menuEnd?.startIndex)!])
                    //배열에 추가
                    menuStart = menuEnd
                }
            }
        }
        //사림관 파싱
        if let docSarim = Kanna.HTML(html: apiData, encoding: CFStringConvertEncodingToNSStringEncoding(0x0422))  {
            
            var article = docSarim.text
            
            for i in 0..<sign.count {                               //특수기호 제거
                article = article!.stringByReplacingOccurrencesOfString(sign[i], withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
            
            for j in 0..<sarim.count    {               //메뉴 구분
                var menuStart = article!.rangeOfString(sarimStart[j], options: NSStringCompareOptions.LiteralSearch, range: (article!.startIndex)..<(article!.endIndex), locale: nil)
                
                for _ in 0..<5   {                        //요일 구분
                    let menuEnd = article!.rangeOfString("\r\n   ", options: NSStringCompareOptions.LiteralSearch, range: (menuStart?.endIndex)!..<(article!.endIndex), locale: nil)
                    
                    sarim[j].append(article![(menuStart?.endIndex)!..<(menuEnd?.startIndex)!])
                    
                    menuStart = menuEnd
                }
            }
        }
        //봉림관 파싱
        if let docBongrim = Kanna.HTML(html: apiDataB, encoding: CFStringConvertEncodingToNSStringEncoding(0x0422))  {
            var article = docBongrim.text
            
            for i in 0..<sign.count {                               //특수기호 제거
                article = article!.stringByReplacingOccurrencesOfString(sign[i], withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
            
            for j in 0..<bongrim.count    {             //메뉴 구분
                var menuStart = article!.rangeOfString(bongrimStart[j], options: NSStringCompareOptions.LiteralSearch, range: (article!.startIndex)..<(article!.endIndex), locale: nil)
                
                for _ in 0..<5   {                         //요일 구분
                    let menuEnd = article!.rangeOfString("\r\n   ", options: NSStringCompareOptions.LiteralSearch, range: (menuStart?.endIndex)!..<(article!.endIndex), locale: nil)
                    
                    bongrim[j].append(article![(menuStart?.endIndex)!..<(menuEnd?.startIndex)!])
                    
                    menuStart = menuEnd
                }
            }
        }
    }
    func toDay(day: Int) {      //텍스뷰 출력함수 월요일부터 일요일까지 숫자를 팔라멘트로 받음
        if day < 5  {       //월~금요일까지
            textDomiA.attributedText = underlining("[기숙사생용]\n" + dormitory[day][0], size: 2)
            textDomiB.attributedText = underlining("[기숙사생용]\n" + dormitory[day][1], size: 2)
            textDomiC.attributedText = underlining("[2,400원]\n" + dormitory[day][2], size: 2)        //3,5,7은 nil값
            textDomiD.attributedText = underlining("[2,400원]\n" + dormitory[day][4], size: 2)
            textDomiE.attributedText = underlining("[3,200원]\n" + dormitory[day][6], size: 2)
            textDomiF.attributedText = underlining("[기숙사생용]\n" + dormitory[day][9], size: 2)
            textDomiG.attributedText = underlining("[기숙사생용]\n" + dormitory[day][8], size: 2)
            
//            //0, 점심, 1 저녁, 2, 학 점, 3,학 저, 4 학 분
            //교직원 점심
            //let replaceString2 = bongrim[4][day] as NSString
            
            textBongA.attributedText = underlining("[교직원:3,300원, 일반:4,000원]\n" + bongrim[0][day], size: 2)
            //학생 점심
            textBongB.attributedText = underlining("[1,900원]\n" + bongrim[2][day], size: 2)
            //교직원 저녁
            textBongC.attributedText = underlining("[교직원:3,300원, 일반:4,000원]\\n" + bongrim[1][day], size: 2)
            //학생 저녁
            textBongD.attributedText = underlining("[1,900원]\n" + bongrim[3][day], size: 2)
            //학생 분식
            textBongE.attributedText = underlining("학생 분식\n" + bongrim[4][day], size: 1)
            
            //0 양식, 1 한식, 2, 정식 (점심/저녁) 3 분식
            let replaceString : NSString = sarim[2][day] as NSString
        
            let range = replaceString.rangeOfString("[석식]")


            
//            let dinnerString = replaceString.substringFromIndex(NSMaxRange(range))
//            
//            print(lauchString)
//            print(dinnerString)
            //let range2 = replaceString.rangeOfString("[석식]")
            //replaceString = replaceString.substringWithRange(range2)
            //print(replaceString)
            
            textSarimA.attributedText = underlining("[1,900원]" + replaceString.substringToIndex(NSMaxRange(range)-4).stringByReplacingOccurrencesOfString("[중식]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), size: 2)
            textSarimB.attributedText = underlining("[1,900원]" + replaceString.substringFromIndex(NSMaxRange(range)), size: 2)
            textSarimC.attributedText = underlining("[2,500원/3,300원]\n" + sarim[0][day], size: 2)
            textSarimD.attributedText = underlining("[2,500원]\n" + sarim[1][day], size: 2)
            textSarimE.attributedText = underlining("[라면:2,000원, 공기밥:500원]\n" + sarim[3][day], size: 2)
            
        } else  {       //토~일요일까지
           textDomiA.attributedText = underlining("[기숙사생용]\n" + dormitory[day][0], size: 2)
            textDomiB.attributedText = underlining("[기숙사생용]\n" + dormitory[day][1], size: 2)
            textDomiC.attributedText = underlining("[2,400원]\n" + dormitory[day][2], size: 2)        //3,5,7은 nil값
            textDomiD.attributedText = underlining("[2,400원]\n" + dormitory[day][4], size: 2)
            textDomiE.attributedText = underlining("[3,200원]\n" + dormitory[day][6], size: 2)
            textDomiF.attributedText = underlining("[기숙사생용]\n" + dormitory[day][9], size: 2)
            textDomiG.attributedText = underlining("[기숙사생용]\n" + dormitory[day][8], size: 2)
            
            textBongA.text = "주말 미운영"
            textBongB.text = "주말 미운영"
            textBongC.text = "주말 미운영"
            textBongD.text = "주말 미운영"
            textBongE.text = "주말 미운영"
            
            textSarimA.text = "주말 미운영"
            textSarimB.text = "주말 미운영"
            textSarimC.text = "주말 미운영"
            textSarimD.text = "주말 미운영"
            textSarimE.text = "주말 미운영"
        }
        
        self.textDomiA.textAlignment = NSTextAlignment.Center
        self.textDomiB.textAlignment = NSTextAlignment.Center
        self.textDomiC.textAlignment = NSTextAlignment.Center
        self.textDomiD.textAlignment = NSTextAlignment.Center
        self.textDomiE.textAlignment = NSTextAlignment.Center
        self.textDomiF.textAlignment = NSTextAlignment.Center
        self.textDomiG.textAlignment = NSTextAlignment.Center

        self.textBongA.textAlignment = NSTextAlignment.Center
        self.textBongB.textAlignment = NSTextAlignment.Center
        self.textBongC.textAlignment = NSTextAlignment.Center
        self.textBongD.textAlignment = NSTextAlignment.Center
        self.textBongE.textAlignment = NSTextAlignment.Center
        //self.textBongE.font = UIFont(name: "System", size: 3)
        
        self.textSarimA.textAlignment = NSTextAlignment.Center
        self.textSarimB.textAlignment = NSTextAlignment.Center
        self.textSarimC.textAlignment = NSTextAlignment.Center
        self.textSarimD.textAlignment = NSTextAlignment.Center
        self.textSarimE.textAlignment = NSTextAlignment.Center
        
        let viewHeight = self.view.bounds.height
        
        switch viewHeight {
        case 480:
            self.textDomiA.font = UIFont.systemFontOfSize(6)
            self.textDomiB.font = UIFont.systemFontOfSize(6)
            self.textDomiC.font = UIFont.systemFontOfSize(6)
            self.textDomiD.font = UIFont.systemFontOfSize(6)
            self.textDomiE.font = UIFont.systemFontOfSize(6)
            self.textDomiF.font = UIFont.systemFontOfSize(6)
            self.textDomiG.font = UIFont.systemFontOfSize(6)
            self.textBongA.font = UIFont.systemFontOfSize(6)
            self.textBongB.font = UIFont.systemFontOfSize(6)
            self.textBongC.font = UIFont.systemFontOfSize(6)
            self.textBongD.font = UIFont.systemFontOfSize(6)
            self.textSarimA.font = UIFont.systemFontOfSize(6)
            self.textSarimB.font = UIFont.systemFontOfSize(6)
            self.textSarimC.font = UIFont.systemFontOfSize(6)
            self.textSarimD.font = UIFont.systemFontOfSize(6)
            
            self.textBongE.font = UIFont.systemFontOfSize(4)
            self.textSarimE.font = UIFont.systemFontOfSize(5)
            break
        case 568:
            self.textDomiA.font = UIFont.systemFontOfSize(8)
            self.textDomiB.font = UIFont.systemFontOfSize(8)
            self.textDomiC.font = UIFont.systemFontOfSize(8)
            self.textDomiD.font = UIFont.systemFontOfSize(8)
            self.textDomiE.font = UIFont.systemFontOfSize(8)
            self.textDomiF.font = UIFont.systemFontOfSize(8)
            self.textDomiG.font = UIFont.systemFontOfSize(8)
            self.textBongA.font = UIFont.systemFontOfSize(8)
            self.textBongB.font = UIFont.systemFontOfSize(8)
            self.textBongC.font = UIFont.systemFontOfSize(8)
            self.textBongD.font = UIFont.systemFontOfSize(8)
            self.textSarimA.font = UIFont.systemFontOfSize(8)
            self.textSarimB.font = UIFont.systemFontOfSize(8)
            self.textSarimC.font = UIFont.systemFontOfSize(8)
            self.textSarimD.font = UIFont.systemFontOfSize(8)
            
            
            self.textBongE.font = UIFont.systemFontOfSize(7)
            self.textSarimE.font = UIFont.systemFontOfSize(7)
            break
        case 667:
            self.textBongE.font = UIFont.systemFontOfSize(9)
            self.textSarimE.font = UIFont.systemFontOfSize(9)
            break
            
        default:
            break
        }

    }
    //사림관뷰로 이동
    @IBAction func moveSarim(sender: UIButton) {
        var frame = scroll.frame
        frame.origin.x = frame.size.width * 2
        frame.origin.y = 0
        scroll.scrollRectToVisible(frame, animated: true)
        anmateSelectedBar(2)
    }
    //봉림관뷰로 이동
    @IBAction func moveBong(sender: UIButton) {
        var frame = scroll.frame
        frame.origin.x = frame.size.width
        frame.origin.y = 0
        scroll.scrollRectToVisible(frame, animated: true)
        anmateSelectedBar(1)
    }
    //기숙사뷰로 이동
    @IBAction func moveDomi(sender: UIButton) {
        let scrollPoint = CGPointMake(0.0, 0.0)
        scroll.setContentOffset(scrollPoint, animated: true)
        anmateSelectedBar(0)
    }
    
    func anmateSelectedBar(index : Int) {
        isActMoveStatus = true
        UIView.animateWithDuration(0.5, animations: {
            self.statusBar.transform = CGAffineTransformMakeTranslation(self.statusBar.frame.width*CGFloat(index), 0);
            }, completion: {finished in
                self.isActMoveStatus = false
        })
    }
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isActMoveStatus == false {
            let indexPage = scrollView.contentOffset.x / scrollView.frame.width
        
            UIView.animateWithDuration(0.0, animations: {
                self.statusBar.transform = CGAffineTransformMakeTranslation(self.statusBar.frame.width*CGFloat(indexPage), 0);
            })
        }
    }
    @IBAction func selectDate(sender: AnyObject) {
        self.selectedView.hidden = false
        self.datePickerView.hidden = false
    }
    
    func settingDate()  {
        toDay(getToDayOfWeek())
        self.titleLb.text = datePicker[getToDayOfWeek()] + " 식단표"
    }
    func getToDayOfWeek()->Int {
        let date = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: date)
        var weekDay = myComponents.weekday
        
        switch weekDay {
        case 0:
            weekDay = 5
        case 1:
            weekDay = 6
        default:
            weekDay = weekDay - 2
        }
        return weekDay
    }

    //PICKERVIEW DELGATE
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datePicker.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datePicker[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.toDay(row)
        self.titleLb.text = datePicker[row] + " 식단표"
        self.selectedView.hidden = true
        self.datePickerView.hidden = true
        
    }
    @IBAction func actCancel(sender: AnyObject) {
        self.selectedView.hidden = true
        self.datePickerView.hidden = true
    }
    func underlining(content : String,size: Int) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        
        let attrString = NSMutableAttributedString(string: content)
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle,range: NSMakeRange(0, attrString.length))
        return attrString
    }

}
