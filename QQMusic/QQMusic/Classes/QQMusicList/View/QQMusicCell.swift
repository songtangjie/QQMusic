//
//  QQMusicCell.swift
//  QQMusic
//
//  Created by William on 16/6/9.
//  Copyright © 2016年 William. All rights reserved.
//

import UIKit

enum QQMusicCellAnimationType : Int {
    case Rotation
    case Scale
}

class QQMusicCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var musicNameLabel: UILabel!
    
    @IBOutlet weak var singerNameLabel: UILabel!
    
    var musicM : QQMusicModel?{
        didSet{
            if musicM?.icon != nil {
                iconImageView.image = UIImage(named: (musicM?.icon)!)
            }
            musicNameLabel.text = musicM?.name
            singerNameLabel.text = musicM?.singer
        }
    }
    
    class func cellWithTabelView(tableView : UITableView) -> QQMusicCell{
        let ID = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as? QQMusicCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("QQMusicCell", owner: nil, options: nil).first as? QQMusicCell
        }
        return cell!
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = iconImageView.width * 0.5
        iconImageView.layer.masksToBounds = true
    }
    
    func animation(type : QQMusicCellAnimationType){
        if type == .Rotation {
            self.layer.removeAnimationForKey("rotation")
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.values = [-M_PI * 0.25,0,M_PI * 0.25,0]
            animation.duration = 0.5
            self.layer.addAnimation(animation, forKey: "rotation")
        }else if type == .Scale{
            self.layer.removeAnimationForKey("scale")
            let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
            animation.values = [0.5,1,0.5,1]
            animation.duration = 0.5
            self.layer.addAnimation(animation, forKey: "scale")
        }
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {

    }
}
