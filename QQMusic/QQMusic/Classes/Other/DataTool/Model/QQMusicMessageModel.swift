//
//  QQMusicMessageModel.swift
//  QQMusic
//
//  Created by William on 16/6/9.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {
    var musicM: QQMusicModel?
    
    var costTime: NSTimeInterval = 0
    var totalTime: NSTimeInterval  = 0
    var isPlaying: Bool = false
    
    var costTimeFormat : String{
        get{
            return QQTimeTool.getFormatTime(costTime)
        }
    }
    var totalTimeFormat : String {
        get{
            return QQTimeTool.getFormatTime(totalTime)
        }
    }
    
    
}
