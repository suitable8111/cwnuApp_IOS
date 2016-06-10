//
//  BoardTableViewCell.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 7..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit


//BoardViewController 안에 있는 TableViewCell 내부 파라매터
class BoardTableViewCell : UITableViewCell {
    

    @IBOutlet var thumbNailImge: UIImageView!
    
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var updateBtn: UIButton!
//    @IBOutlet var goodLabel: UILabel!
//    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var postTimeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var viewCountLabel: UILabel!
    
    
}
