//
//  QQLrcCell.swift
//  QQMusic
//
//  Created by William on 16/6/10.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class QQLrcCell: UITableViewCell {

    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    var progress : CGFloat = 0{
        didSet{
            lrcLabel.progress = progress
        }
    }
    
    var lrcM : QQLrcModel?{
        didSet{
            lrcLabel.text = lrcM?.lrcContent
        }
    }
    
    class func cellWithTableView(tableView : UITableView) -> QQLrcCell {
        let ID = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as? QQLrcCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("QQLrcCell", owner: nil, options: nil).first as? QQLrcCell
        }
        return cell!
    }
    
}
