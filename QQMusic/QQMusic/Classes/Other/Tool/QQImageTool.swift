//
//  QQImageTool.swift
//  QQMusic
//
//  Created by William on 16/6/10.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class QQImageTool: NSObject {

    class func getImage(sourceImage : UIImage ,text : String?) -> UIImage {
        if text == nil || text! == "" {
            return sourceImage
        }
        
        UIGraphicsBeginImageContext(sourceImage.size)
        sourceImage.drawInRect(CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height))
        let style : NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.alignment = .Center
        let dict : [String : AnyObject] = [
            NSFontAttributeName : UIFont.systemFontOfSize(18),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSParagraphStyleAttributeName : style
        ]
        (text! as NSString).drawInRect(CGRectMake(0, 0, sourceImage.size.width, 28), withAttributes: dict)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
