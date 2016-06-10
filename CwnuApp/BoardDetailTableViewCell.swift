//
//  BoardDetailTableViewCell.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 4. 8..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit

class BoardDetailTableViewCell  : UITableViewCell {
    @IBOutlet var detailThumbnailImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var postTimeLabel: UILabel!
    @IBOutlet var updateBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
}
