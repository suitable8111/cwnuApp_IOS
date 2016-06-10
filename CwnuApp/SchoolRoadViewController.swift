//
//  SchoolRoadViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 13..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

class SchoolRoadViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController : UIPageViewController!
    var pageTitles : NSArray!
    var movePos : Int = 0
    
    @IBOutlet var selectedBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTitles = NSArray(objects: "식당","배달","커피","주점")
        
        //PageViewController를 storyboard에서 생성한다.
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SchoolRoadPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0)
        
        let viewContrllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        //PageViewController 위치선전
        self.pageViewController.view.frame = CGRectMake(0, 130, self.view.frame.width, self.view.frame.size.height - 80)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
    }
    func viewControllerAtIndex(index : Int ) -> UIViewController {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)){
            return SchoolRoadContentViewController()
        }
        let vc : SchoolRoadContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SchoolRoadContentViewController") as! SchoolRoadContentViewController
        vc.pageIndex = index
        
        return vc
    }
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as? SchoolRoadContentViewController
        var index = vc!.pageIndex as Int
        anmateSelectedBar(index)
        movePos = index
        
        if (index == 0 || index == NSNotFound){
            return nil
        }
        index -= 1
        print(movePos)
        return self.viewControllerAtIndex(index)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as? SchoolRoadContentViewController
        var index = vc!.pageIndex as Int
        anmateSelectedBar(index)
        movePos = index
        if index == NSNotFound {
            return nil
        }
        index += 1
        
        print(movePos)
        if index == pageTitles.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction func actBR(sender: AnyObject) {
        print(movePos)
        if movePos != 3 {
            let startVC = self.viewControllerAtIndex(3)
            self.anmateSelectedBar(3)
            let viewContrllers = NSArray(object: startVC)
            self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
            movePos = 3
        }
    
    }
    @IBAction func actCF(sender: AnyObject) {
        print(movePos)
        if movePos != 2 {
            let startVC = self.viewControllerAtIndex(2)
            self.anmateSelectedBar(2)
            let viewContrllers = NSArray(object: startVC)
        
            if movePos < 2 {
                self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
            }else if movePos > 2 {
                self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Reverse, animated: true, completion: nil)
            }
            movePos = 2
        }
        
    }
    @IBAction func actDB(sender: AnyObject) {
        print(movePos)
        if movePos != 1 {
            let startVC = self.viewControllerAtIndex(1)
            self.anmateSelectedBar(1)
            let viewContrllers = NSArray(object: startVC)
        
            if movePos < 1 {
                self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
            }else if movePos > 1 {
                self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Reverse, animated: true, completion: nil)
            }
            movePos = 1
        }
    }
    
    @IBAction func actCT(sender: AnyObject) {
        print(movePos)
        if movePos != 0 {
        
            let startVC = self.viewControllerAtIndex(0)
            self.anmateSelectedBar(0)
        
            let viewContrllers = NSArray(object: startVC)
            self.pageViewController.setViewControllers(viewContrllers as? [UIViewController], direction: .Reverse, animated: true, completion: nil)
            movePos = 0
        }
    }
    
    @IBAction func actBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //selected 애니메이션 구현
    func anmateSelectedBar(index : Int) {
        UIView.animateWithDuration(0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.selectedBar.transform = CGAffineTransformMakeTranslation(self.selectedBar.frame.width*CGFloat(index), 0);
            }, completion: nil)
    }
}
