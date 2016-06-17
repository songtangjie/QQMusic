//
//  QQMusicModel.swift
//  QQMusic
//
//  Created by William on 16/6/9.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class QQMusicModel: NSObject {
    /** 歌曲名称 */
    var name: String?
    
    /** 歌曲文件名称 */
    var filename: String?
    
    /** 歌词文件名称 */
    var lrcname: String?
    
    /** 歌手名称 */
    var singer: String?
    
    /** 歌手头像 */
    var singerIcon: String?
    
    /** 专辑图片 */
    var icon: String?
    
    override init() {
        super.init()
    }
    init(dict : [String : AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}
