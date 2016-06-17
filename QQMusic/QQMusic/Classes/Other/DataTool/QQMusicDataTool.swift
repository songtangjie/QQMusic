//
//  QQMusicDataTool.swift
//  QQMusic
//
//  Created by William on 16/6/9.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class QQMusicDataTool: NSObject {
    class func getMusicMs(result : (musicMs : [QQMusicModel]?) -> ()) {
        //加载plist{
        guard let path = NSBundle.mainBundle().pathForResource("Musics.plist", ofType: nil) else{
            result(musicMs: nil)
            return
        }
        guard let dictArray = NSArray(contentsOfFile: path) else{
            result(musicMs: nil)
            return
        }
        //遍历字典
        var tempMusicMs = [QQMusicModel]()
        for dict in dictArray {
            //字段转模型
            let model = QQMusicModel(dict: dict as! [String : AnyObject])
            tempMusicMs.append(model)
        }
        //返回结果
        result(musicMs: tempMusicMs)
    }
    class func getLrcMData(lrcName : String) -> [QQLrcModel] {
        //获取歌词文件路径
        guard let path = NSBundle.mainBundle().pathForResource(lrcName, ofType: nil) else{
            return [QQLrcModel]()
        }
        //获取歌词文件内容
        var lrcContent : String?
        do{
            lrcContent = try String(contentsOfFile: path)
        }catch{
            print(error)
            return [QQLrcModel]()
        }
        if lrcContent == nil {
            return [QQLrcModel]()
        }
        //解析歌词
        var lrcMs = [QQLrcModel]()
        let lrcStrArray = lrcContent!.componentsSeparatedByString("\n")
        for lrcStr in lrcStrArray {
            //过滤垃圾数据
            if lrcStr.containsString("[ti:") || lrcStr.containsString("[ar:") || lrcStr.containsString("[al:") {
                continue
            }
            //拿到正确数据
            let resultStr = lrcStr.stringByReplacingOccurrencesOfString("[", withString: "")
            let timeAndLrc = resultStr.componentsSeparatedByString("]")
            if timeAndLrc.count == 2 {
                let timeFormat = timeAndLrc[0]
                let lrc = timeAndLrc[1]
                let lrcM = QQLrcModel()
                lrcM.startTime = QQTimeTool.getTime(timeFormat)
                lrcM.lrcContent = lrc
                lrcMs.append(lrcM)
            }
        }
        for i in 0..<lrcMs.count {
            if i == lrcMs.count - 1 {
                break
            }
            lrcMs[i].endTime = lrcMs[i + 1].startTime
        }
        return lrcMs
    }
    class func getRowLrcM(lrcMs : [QQLrcModel],currentTime : NSTimeInterval) -> (row : Int,lrcM : QQLrcModel?){
        for i in 0..<lrcMs.count {
            if currentTime > lrcMs[i].startTime && currentTime < lrcMs[i].endTime {
                return (i,lrcMs[i])
            }
        }
        return (0,nil)
    }
}
