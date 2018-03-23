//
//  VideoOperatorView.swift
//  AVPlayerPrimary
//
//  Created by 陈岩 on 2018/3/22.
//  Copyright © 2018年 陈岩. All rights reserved.
//

import UIKit
import PureLayout
import AVFoundation
import AVKit
import Photos

class VideoOperatorView: UIView {

    var controller: UIViewController!
    var url: URL!
    
    var buttons = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config_subviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config_subviews() {
        let meng = UIVisualEffectView(frame: DEVICE_RECT)
        meng.effect = UIBlurEffect(style: .light)
        addSubview(meng)
        //backgroundColor = UIColor.white
        
        let titles = ["预览","保存","上传","保存并上传","管理","取消"]
        let widthLeft = DEVICE_WIDTH / 3
        let heightTop: CGFloat = (DEVICE_HEIGHT - 400) / 2
        for index in 0 ..< 6 {
            let rect = CGRect(x: 0, y: 0, width: 120, height: 80)
            let point = CGPoint(x: widthLeft * CGFloat(index % 2 + 1), y: heightTop + 40 + 120 * CGFloat(index / 2))
            
            let button = UIButton(frame: rect)
            button.center = point
            
            button.backgroundColor = UIColor.red
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitle(titles[index], for: .normal)
            button.addTarget(self, action: #selector(clickSender(_:)), for: .touchUpInside)
            button.tag = index
            meng.addSubview(button)
            buttons.append(button)
        }
    }
    
    @objc func clickSender(_ sender: UIButton) {
        removeFromSuperview()
        
        switch sender.tag {
        case 0:
            if let videoUrl = self.url {
                let player = AVPlayer(url: videoUrl)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.controller.present(playerController, animated: true, completion: nil)
            }
        case 1:
            saveVideoToAlbum(self.url)
        case 4:
            managerAllVideos()
        case 5:
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y = DEVICE_HEIGHT
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        default:
            break
        }
    }
    
    //将视频保存到本地
    func saveVideoToAlbum(_ videoUrl: URL?) {
        var message: String!
        if let url = videoUrl {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }, completionHandler: { (success, error) in
                if success {
                    message = "保存成功"

                } else {
                    message = "保存失败：\(String(describing: error))"
                }
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
                    self.controller.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    // 管理 Document 文件夹下 所有视频
    func managerAllVideos() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let pathString = path[0] as String
        let list = try? FileManager.default.contentsOfDirectory(atPath: pathString)
        
        if let _ = list {
            let managerVideoVC = VideosManagerController()
            self.controller.navigationController?.pushViewController(managerVideoVC, animated: true)
        }
    }
    
}
