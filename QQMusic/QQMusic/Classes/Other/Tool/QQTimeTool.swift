//
//  QQTimeTool.swift
//  QQMusic
//
//  Created by William on 16/6/9.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class QQTimeTool: NSObject {
    class func getFormatTime(time : NSTimeInterval) -> String {
        let min = Int(time) / 60
        let sec = Int(time) % 60
        return String(format: "%02d:%02d",min,sec)
    }
    class func getTime(format : String) -> NSTimeInterval {
        let minSec = format.componentsSeparatedByString(":")
        if minSec.count == 2 {
            let min = Double(minSec[0])
            let sec = Double(minSec[1])
            return min! * 60 + sec!
        }
        return 0
    }
}
