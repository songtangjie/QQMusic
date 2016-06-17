//
//  QQLrcLabel.swift
//  QQMusic
//
//  Created by William on 16/6/9.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {
    
    var progress : CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        UIColor.greenColor().set()
        UIRectFillUsingBlendMode(CGRectMake(0, 0, rect.size.width * progress, rect.size.height), CGBlendMode.SourceIn)
    }
}
