//
//  QQMusicListTVC.swift
//  QQMusic
//
//  Created by William on 16/6/9.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

class QQMusicListTVC: UITableViewController {
    //数据源
    var musicMs : [QQMusicModel] = [QQMusicModel](){
        didSet{
            tableView.reloadData()
        }
    }

}
//主业务逻辑
extension QQMusicListTVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        QQMusicDataTool.getMusicMs { (musicMs) in
            if musicMs != nil{
                self.musicMs = musicMs!
            }
        }
        //工具类赋值播放列表
        QQMusicOperationTool.shareInstance.musicList = musicMs
    }
}
//功能实现
extension QQMusicListTVC{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取出数据模型
        let musicM = musicMs[indexPath.row]
        QQMusicOperationTool.shareInstance.playMusic(musicM)
        //跳转到播放详情页面
        performSegueWithIdentifier("listToDetail", sender: nil)
    }
}
//展示数据
extension QQMusicListTVC{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicMs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = QQMusicCell.cellWithTabelView(tableView)
        //取出数据模型
        let musicM = musicMs[indexPath.row]
        //给cell赋值
        cell.musicM = musicM
        return cell
    }
}
//界面处理
extension QQMusicListTVC{
    func setUpView() {
        setBackView()
        setUpTableView()
        setUpNavBar()
    }
    //设置背景图片
    func setBackView(){
        let image = UIImage(named: "QQListBack")
        let imageView = UIImageView(image: image)
        tableView.backgroundView = imageView
    }
    //tableView设置
    func setUpTableView(){
        tableView.rowHeight = 60
        tableView.separatorStyle = .None
    }
    //隐藏导航栏
    func setUpNavBar(){
        navigationController?.navigationBarHidden = true
    }
    //设置状态栏
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
//动画处理
extension QQMusicListTVC{
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //取出cell
        let musicCell = cell as! QQMusicCell
        //动画
        musicCell.animation(QQMusicCellAnimationType.Scale)
    }
}
