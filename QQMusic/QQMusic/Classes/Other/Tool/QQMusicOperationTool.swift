//
//  QQMusicOperationTool.swift
//  QQMusic
//
//  Created by William on 16/6/9.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit
import MediaPlayer

class QQMusicOperationTool: NSObject {
    //记录上一次绘制的行号
    var lastRow = 0
    
    //创建专辑图片
    var artWork : MPMediaItemArtwork?
    
    private var musicMessageM : QQMusicMessageModel = QQMusicMessageModel()
    
    static let shareInstance = QQMusicOperationTool()
    
    var musicList : [QQMusicModel]?
    
    var currentIndex : Int = 0{
        didSet{
            if currentIndex < 0 {
                currentIndex = (musicList?.count)! - 1
            }
            if currentIndex > (musicList?.count)! - 1{
                currentIndex = 0
            }
        }
    }
    
    //播放歌曲
    private let playTool : QQMusicTool = QQMusicTool()
    
    func getMusicMessageM() -> QQMusicMessageModel{
        if musicList == nil {
            return musicMessageM
        }
        musicMessageM.musicM = musicList![currentIndex]
        musicMessageM.costTime = (playTool.player?.currentTime)!
        musicMessageM.totalTime = (playTool.player?.duration)!
        musicMessageM.isPlaying = (playTool.player?.playing)!
        
        return musicMessageM
    }
    
    //根据音乐模型播放一首歌
    func playMusic(musicM : QQMusicModel) {
        playTool.playMusic(musicM.filename)
        //根据模型计算在播放列表的索引
        guard let musicMs = musicList else{
            print("没有播放列表, 只能播放单首歌曲")
            return
        }
        currentIndex = musicMs.indexOf(musicM)!
    }
    
    func playCurrentMusic(){
        playTool.playCurrentMusic()
    }
    
    func pauseCurrentMusic(){
        playTool.pauseCurrentMusic()
    }
    
    func nextMusic(){
        //调整索引
        currentIndex += 1
        //获取对应的模型
        let musicM = musicList![currentIndex]
        playMusic(musicM)
        
    }
    
    func preMusic(){
        //调整索引
        currentIndex -= 1
        //获取对应的模型
        let musicM = musicList![currentIndex]
        playMusic(musicM)
    }
    
    func setTime (currentTime : NSTimeInterval){
        playTool.setTime(currentTime)
    }
    //设置锁屏信息
    func setUpLockMessage(){
        //取出需要展示的信息类型
        let musicMessageM = getMusicMessageM()
        //获取锁屏中心
        let infoCenter = MPNowPlayingInfoCenter.defaultCenter()
        //创建信息字典
        var name = ""
        var singer = ""
        if musicMessageM.musicM?.name != nil {
            name = (musicMessageM.musicM?.name)!
        }
        if musicMessageM.musicM?.singer != nil {
            singer = (musicMessageM.musicM?.singer)!
        }
        

        let imageName = musicMessageM.musicM?.icon
        if imageName != nil {
            let image = UIImage(named:imageName!)
            if image != nil {
                //获取歌词数组
                let musicM = musicMessageM.musicM
                if  musicM?.lrcname != nil{
                    let lrcMs = QQMusicDataTool.getLrcMData((musicM?.lrcname)!)
                    //获取正在播放的歌词
                    let rowLrcM = QQMusicDataTool.getRowLrcM(lrcMs, currentTime: musicMessageM.costTime)
                    //获取当前歌词信息
                    if lastRow != rowLrcM.row{
                        lastRow = rowLrcM.row
                        //文字加到图片上
                        let resultImage = QQImageTool.getImage(image!, text: rowLrcM.lrcM?.lrcContent)
                        artWork = MPMediaItemArtwork(image: resultImage)
                        
                    }
                }
            }
        }
        
        let infoDict : NSMutableDictionary = NSMutableDictionary()
        infoDict.setValue(name, forKey: MPMediaItemPropertyAlbumTitle)
        infoDict.setValue(singer, forKey: MPMediaItemPropertyArtist)
        infoDict.setValue(musicMessageM.totalTime, forKey: MPMediaItemPropertyPlaybackDuration)
        infoDict.setValue(musicMessageM.costTime, forKey: MPNowPlayingInfoPropertyElapsedPlaybackTime)
        
        if artWork != nil {
            infoDict.setValue(artWork!, forKey: MPMediaItemPropertyArtwork)
        }
        let infoDict2 = infoDict.copy()
        
        //设置信息
        infoCenter.nowPlayingInfo = infoDict2 as? [String : AnyObject]
        //接收远程事件
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
}
