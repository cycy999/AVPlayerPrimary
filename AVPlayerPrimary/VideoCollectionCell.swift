//
//  VideoCollectionCell.swift
//  AVPlayerPrimary
//
//  Created by 陈岩 on 2018/3/23.
//  Copyright © 2018年 陈岩. All rights reserved.
//

import UIKit

class VideoCollectionCell: UICollectionViewCell {
    
    
    var videoInterface: UIImageView!
    var effectView: UIVisualEffectView!
    var selectedButton: UIButton!
    var videoIsChoose = false {
        didSet {
            if videoIsChoose {
                effectView.alpha = 0
            } else {
                effectView.alpha = 0.4
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        config_subviews()
    }
    
    func config_subviews() {
        videoInterface = UIImageView(frame: self.contentView.bounds)
        
        self.contentView.addSubview(videoInterface)
        
        let playIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        playIcon.image = UIImage(named: "iw_playIcon")
        playIcon.center = CGPoint(x: videoInterface.bounds.width / 2, y: videoInterface.bounds.height / 2)
        videoInterface.addSubview(playIcon)
        
        selectedButton = UIButton(frame: CGRect(x: 3, y: 3, width: 20, height: 20))
        selectedButton.setBackgroundImage(UIImage(named: "iw_unselected"), for: .normal)
        selectedButton.setBackgroundImage(UIImage(named: "iw_selected"), for: .selected)
        videoInterface.addSubview(selectedButton)
        selectedButton.isHidden = true
        
        effectView = UIVisualEffectView(frame: videoInterface.bounds)
        effectView.effect = UIBlurEffect(style: .dark)
        effectView.alpha = 0
        videoInterface.addSubview(effectView)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
