//
//  QQMusicTool.swift
//  QQMusic
//
//  Created by William on 16/6/9.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit
import AVFoundation

let kPlayerFinishNotification = "playFinish"

class QQMusicTool: NSObject {
    
    override init() {
        super.init()
        //获取音频会话
        let sesseion = AVAudioSession.sharedInstance()
        //设置会话类别
        do{
            try sesseion.setCategory(AVAudioSessionCategoryPlayback)
            //激活会话
            try sesseion.setActive(true)
        }
        catch{
            return
        }
        
    }
    
    //记录当前正在播放的对象
    var player : AVAudioPlayer?
    //根据歌曲名称播放歌
    func playMusic(name : String?) {
        //获取url
        guard let url = NSBundle.mainBundle().URLForResource(name, withExtension: nil) else{
            return
        }
        //获取旧的Url和新获取的对比
        if player?.url == url {
            player?.play()
            return
        }
        do{
            //创建一个播放器
            player = try AVAudioPlayer(contentsOfURL: url)
            player?.delegate = self
        }
        catch{
            print(error)
            return
        }
        //准备播放
        player?.prepareToPlay()
        //开始播放
        player?.play()
    }
    func pauseCurrentMusic() {
        player?.pause()
    }
    func playCurrentMusic() {
        player?.play()
    }
    func stopCurrentMusic() {
        player?.currentTime = 0
        player?.stop()
    }
    
    func setTime(currentTime : NSTimeInterval){
        player?.currentTime = currentTime
    }
}

extension QQMusicTool : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName(kPlayerFinishNotification,object : nil)
    }
}
