//
//  MainLoginViewController.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 2..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

class MainLoginViewController : UIViewController, UIAlertViewDelegate {
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        let session: KOSession = KOSession.sharedSession();
        
        if session.isOpen() {
            session.close()
        }
        
        session.presentingViewController = self.navigationController
        session.openWithCompletionHandler({ (error) -> Void in
            session.presentingViewController = nil
            
            if !session.isOpen() {
                print("에러")
            }
            
            }, authParams: nil, authTypes: [KOAuthType.Talk.rawValue, KOAuthType.Account.rawValue])
    }
}
