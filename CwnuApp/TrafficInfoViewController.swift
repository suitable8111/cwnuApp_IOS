//
//  TrafficInfoViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 11..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

//교통정보 뷰 컨트롤러 PageViewController 를 이용했다.. 뭔가 삽질한 느낌..
//안드로이드의 ViewPager처럼 만들려하는데 처음에는 스크롤 뷰로 하려다가 오토레이아웃이 짜증나서
//PageViewController를 썻지만 이것 역시 더 짜증났다 비추천..
class TrafficInfoViewController : UIViewController, UIPageViewControllerDataSource {
    var pageViewController : UIPageViewController!
    var pageTitles : NSArray!
    var vcIndex : Int? = 1;
    @IBOutlet var selectedBar: UIView!
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "(아이폰)교통정보")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //page타이틀 배열 실제로 쓰이진 않는다.. 삽질 1
        self.pageTitles = NSArray(objects: "교통정보","교내버스","기차정보")
        
        //PageViewController를 storyboard에서 생성한다.
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrafficPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        
        //맨처음 위치를 잡을 ContentView 학교버스를 먼저 보여지도록 할 것이다.
        let midVC = self.viewControllerAtIndex(vcIndex!)
        
        let viewContrllers = NSArray(object: midVC)
        
        self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        //PageViewController 위치선전
        self.pageViewController.view.frame = CGRectMake(0, 105, self.view.frame.width, self.view.frame.size.height - 80)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
    }
    
    func viewControllerAtIndex(index : Int ) -> UIViewController {
        
        //삽질의 시작... 나는 두개의 Content뷰를 index마다 다르게 지정하였다... 차라니 스크롤뷰로 하는게 빠를듯..(오토레이아웃을 몰라서)
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)){
            return BusInfoContentViewController()
        }
        if index <= 0 {
            let vc : BusInfoContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BusInfoContentViewController") as! BusInfoContentViewController
            vc.pageIndex = index
            
            return vc
        }else {
            let vc : TrafficContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TrafficContentViewController") as! TrafficContentViewController
            vc.pageIndex = index
            
            return vc
        }
    }
    
    // MARK: - Page View Controller Data Source
    //이제 앞으로, 뒤로갈때마다 뷰 검사를 우선시한다 그리고 거기에서 pageIndex를 들고와 비교하여 생성 및 제어를 한다.
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let vc = viewController as? TrafficContentViewController {
            vcIndex = vc.pageIndex
        }else {
            let vc = viewController as? BusInfoContentViewController
            vcIndex = vc?.pageIndex
        }
        
        if vcIndex == NSNotFound {
            return nil
        }
        vcIndex! -= 1
        anmateSelectedBar(vcIndex!)
        
        print("Before View")
        print(vcIndex!)
        if vcIndex! == -1 {
            return nil
        }
        
        return viewControllerAtIndex(vcIndex!)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    
        if let vc = viewController as? TrafficContentViewController {
            vcIndex = vc.pageIndex
        }else {
            let vc = viewController as? BusInfoContentViewController
            vcIndex = vc?.pageIndex
        }
        if vcIndex == NSNotFound {
            return nil
        }
        vcIndex! += 1
        anmateSelectedBar(vcIndex!-2)
        print("After View")
        print(vcIndex!)
        if vcIndex! == self.pageTitles.count {
            return nil
        }
        return viewControllerAtIndex(vcIndex!)

    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func actBusInfo(sender: AnyObject) {
        if vcIndex! != 0 {
            let startVC = self.viewControllerAtIndex(0)
            let viewContrllers = NSArray(object: startVC)
            self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Reverse, animated: true, completion: nil)
            vcIndex! = 0
            anmateSelectedBar(-1)
        }
    }
    @IBAction func actSchoolBus(sender: AnyObject) {
        
        if vcIndex! != 1 {
            let startVC = self.viewControllerAtIndex(1)
            let viewContrllers = NSArray(object: startVC)
            if vcIndex! > 1 {
                self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Reverse, animated: true, completion: nil)
            }else if vcIndex! < 1{
                self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
            }
            vcIndex = 1
            anmateSelectedBar(0)
        }
    }
    @IBAction func actTrain(sender: AnyObject) {
        if vcIndex! != 2 {
            let startVC = self.viewControllerAtIndex(2)
            let viewContrllers = NSArray(object: startVC)
            self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
            vcIndex = 2
            anmateSelectedBar(1)
        }
    }
    
    
    
    //selected 애니메이션 구현
    func anmateSelectedBar(index : Int) {
        UIView.animateWithDuration(0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.selectedBar.transform = CGAffineTransformMakeTranslation(self.selectedBar.frame.width*CGFloat(index), 0);
            }, completion: nil)
    }
}
