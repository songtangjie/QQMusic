//
//  QQDeatilVC.swift
//  QQMusic
//
//  Created by William on 16/6/9.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class QQDeatilVC: UIViewController {
    //歌词背景视图
    @IBOutlet weak var lrcScrollView: UIScrollView!
    
    //背景图片
    @IBOutlet weak var backImageView: UIImageView!
    //前景图片
    @IBOutlet weak var foreImageView: UIImageView!
    //歌手名
    @IBOutlet weak var singerNameLabel: UILabel!
    //歌曲名称
    @IBOutlet weak var songNameLabel: UILabel!
    //歌曲总时长
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    
    //歌词
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    //已经播放时长
    @IBOutlet weak var costTimeLabel: UILabel!
    //播放进度
    @IBOutlet weak var progressSlider: UISlider!
    //播放或暂停按钮
    @IBOutlet weak var playOrPauseBtn: UIButton!
    
    var updateTimesTimer : NSTimer?
    
    lazy var lrcTVC : QQLrcTVC = {
        return QQLrcTVC()
    }()
    
    var displayLink : CADisplayLink?
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
//主要业务逻辑
extension QQDeatilVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCustomSubView()
        setUpOnce()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(nextMusic), name: kPlayerFinishNotification, object: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setCustomFrame()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addTimer()
        addDisPlayLink()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
        removeDisPlayLink()
    }
    //关闭
    @IBAction func close(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    //上一首
    @IBAction func preMusic(sender: AnyObject) {
        QQMusicOperationTool.shareInstance.preMusic()
        setUpOnce()
    }
    //下一首
    @IBAction func nextMusic() {
        QQMusicOperationTool.shareInstance.nextMusic()
        setUpOnce()
    }
    //播放或暂停
    @IBAction func playOrPause(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            QQMusicOperationTool.shareInstance.playCurrentMusic()
        }
        else{
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        }
    }
    //拖拽进度条
    @IBAction func change(sender: UISlider) {
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        let currentTime = musicMessageM.totalTime * Double(sender.value)
        costTimeLabel.text = QQTimeTool.getFormatTime(currentTime)
    }
    //添加定时器
    func addTimer(){
        updateTimesTimer = NSTimer(timeInterval: 1, target: self, selector: #selector(QQDeatilVC.setUpTimes), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(updateTimesTimer!, forMode: NSRunLoopCommonModes)
    }
    @IBAction func down(sender: AnyObject) {
        removeTimer()
    }
    @IBAction func up(sender: UISlider) {
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        let currentTime = musicMessageM.totalTime * Double(sender.value)
        QQMusicOperationTool.shareInstance.setTime(currentTime)
        addTimer()
    }
    //移除定时器
    func removeTimer(){
        updateTimesTimer?.invalidate()
        updateTimesTimer = nil
    }
    func addDisPlayLink(){
        displayLink = CADisplayLink(target: self, selector: #selector(updateLrcData))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    func removeDisPlayLink(){
        displayLink?.invalidate()
        displayLink = nil
    }
}
//数据操作
extension QQDeatilVC{
    func setUpTimes(){
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        costTimeLabel.text = musicMessageM.costTimeFormat
        playOrPauseBtn.selected = musicMessageM.isPlaying
        progressSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTime)
    }
    func setUpOnce(){
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        if musicMessageM.musicM?.icon != nil {
            backImageView.image = UIImage(named:(musicMessageM.musicM?.icon)!)
            foreImageView.image = UIImage(named:(musicMessageM.musicM?.icon)!)
        }
        songNameLabel.text = musicMessageM.musicM?.name
        singerNameLabel.text = musicMessageM.musicM?.singer
        totalTimeLabel.text = musicMessageM.totalTimeFormat
        
        addRotationAnimation()
        if musicMessageM.isPlaying {
            resumeRotationAnimation()
        }
        else{
            pauseRotationAnimation()
        }
        //更新歌词
        guard let musicM = musicMessageM.musicM else{
            return
        }
        let lrcMs = QQMusicDataTool.getLrcMData((musicM.lrcname)!)
        lrcTVC.lrcMs = lrcMs
    }
    func updateLrcData(){
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageM()
        //拿到当前行号
        let rowLrcM = QQMusicDataTool.getRowLrcM(lrcTVC.lrcMs, currentTime: musicMessageM.costTime)
        //滚动到对应行
        lrcTVC.scrollRow = rowLrcM.row
        //给歌词赋值
        lrcLabel.text = rowLrcM.lrcM?.lrcContent
        //更新进度
        if rowLrcM.lrcM != nil {
            let progressTime = CGFloat(musicMessageM.costTime - (rowLrcM.lrcM?.startTime)!)
            let totalTime = CGFloat((rowLrcM.lrcM?.endTime)! - (rowLrcM.lrcM?.startTime)!)
            lrcLabel.progress = progressTime / totalTime
            
            lrcTVC.progress = lrcLabel.progress
        }
        
        if UIApplication.sharedApplication().applicationState == .Background {
            QQMusicOperationTool.shareInstance.setUpLockMessage()
        }
    }
}
//界面操作
extension QQDeatilVC{
    //添加控件
    func addCustomSubView(){
        //设置歌词背景占位视图
        lrcScrollView.delegate = self
        lrcScrollView.pagingEnabled = true
        lrcScrollView.showsHorizontalScrollIndicator = false
        lrcScrollView.addSubview(lrcTVC.tableView)
        //设置进度条
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), forState: UIControlState.Normal)
    }
    //布局控件
    func setCustomFrame(){
        //设置前景图片
        foreImageView.layer.cornerRadius = foreImageView.width * 0.5
        foreImageView.clipsToBounds = true
        //设置歌词背景视图大小
        lrcScrollView.contentSize = CGSize(width: lrcScrollView.width * 2, height: 0)
        //设置歌词视图
        lrcTVC.tableView.frame = lrcScrollView.bounds
        lrcTVC.tableView.x = lrcScrollView.width
    }
    //状态栏
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
//动画
extension QQDeatilVC : UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let alpha = 1 - scrollView.contentOffset.x / scrollView.width
        lrcLabel.alpha = alpha
        foreImageView.alpha = alpha
    }
    func addRotationAnimation(){
        foreImageView.layer.removeAnimationForKey("rotate")
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2 * M_PI
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        foreImageView.layer.addAnimation(animation, forKey: "rotate")
    }
    func resumeRotationAnimation(){
        foreImageView.layer.resumeAnimate()
    }
    func pauseRotationAnimation(){
        foreImageView.layer.pauseAnimate()
    }
}