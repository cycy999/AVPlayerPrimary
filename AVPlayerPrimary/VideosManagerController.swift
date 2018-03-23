//
//  VideosManagerController.swift
//  AVPlayerPrimary
//
//  Created by 陈岩 on 2018/3/23.
//  Copyright © 2018年 陈岩. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideosManagerController: UIViewController {

    let margin: CGFloat = 5
    let viewHight: CGFloat = 50
    
    var allVideosPaths = [String]()
    var allImageArray = [UIImage]()
    
    var nsnumberArray = [NSNumber]()
    
    var collectonView: UICollectionView!
    
    var videoIsSelected = false
    
    var operatorVideosArray = [String]()
    
    var operatorVideosImage = [UIImage]()
    
    var bottomView: UIView!
    
    var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allVideosPaths = getAllVideoPaths()
        
        collectonView = config_collection()
        
        config_button()
        
        config_bottomView()
        
        getVideoImages(allVideosPaths)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}


extension VideosManagerController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allVideosPaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCollectionCell
        
        if allVideosPaths.count == allImageArray.count {
            cell.videoInterface.image = allImageArray[indexPath.row]
        }
        
        if videoIsSelected {
            cell.selectedButton.isHidden = false
            cell.videoIsChoose = nsnumberArray[indexPath.row] as! Bool
        } else {
            cell.selectedButton.isHidden = true
            cell.videoIsChoose = nsnumberArray[indexPath.row] as! Bool
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! VideoCollectionCell
        guard videoIsSelected else {
            //  不可选择，点击预览
            let player = AVPlayer.init(url: URL(fileURLWithPath: allVideosPaths[indexPath.row]))
            print(allVideosPaths[indexPath.row])
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true, completion: nil)
            return
        }
        
        //  可选择
        cell.videoIsChoose = !cell.videoIsChoose
        
        if cell.videoIsChoose == true {
            operatorVideosArray.append(allVideosPaths[indexPath.row])
            operatorVideosImage.append(allImageArray[indexPath.row])
        } else {
            let index = operatorVideosArray.index(of: allVideosPaths[indexPath.row])
            operatorVideosArray.remove(at: index!)
            operatorVideosImage.remove(at: index!)
        }
        
        countLabel.text = "\(operatorVideosArray.count)"
        
        nsnumberArray[indexPath.row] = cell.videoIsChoose as NSNumber
        
    }
    
}

extension VideosManagerController {
    
    //视频路径
    func getAllVideoPaths() -> [String] {
        var pathArray = [String]()
        let pathFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let lists = try? FileManager.default.contentsOfDirectory(atPath: pathFolder) {
            for item in lists {
                pathArray.append(pathFolder + "/" + item)
            }
        }
        //  添加标识数组
        for _ in pathArray {
            nsnumberArray.append(1)
        }
        
        return pathArray
        
    }
    
    func config_collection() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: DEVICE_RECT, collectionViewLayout: flowLayout)
        view.addSubview(collection)
        
        collection.delegate = self
        collection.dataSource = self
        let width = (DEVICE_WIDTH - 5 * margin) / 4
        flowLayout.itemSize = CGSize(width: width, height: width)
        collection.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        flowLayout.minimumLineSpacing = margin
        flowLayout.minimumInteritemSpacing = margin
        
        collection.register(VideoCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = UIColor.white
        return collection
    }
    
    func config_button() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.setTitle("选择", for: .normal)
        button.setTitle("取消", for: .selected)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(chooseButtonAction(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func config_bottomView() {
        bottomView = UIView(frame: CGRect(x: 0, y: DEVICE_HEIGHT, width: DEVICE_WIDTH, height: viewHight))
        view.addSubview(bottomView)
        
        let uploadButton = setBottomButtons("上传", center: CGPoint(x: DEVICE_WIDTH / 4, y: viewHight / 2))
        let deleteButton = setBottomButtons("删除", center: CGPoint(x: DEVICE_WIDTH / 4 * 3, y: viewHight / 2))
        
        uploadButton.addTarget(self, action: #selector(uploadAction), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        countLabel.clipsToBounds = true
        countLabel.layer.cornerRadius = 15
        countLabel.backgroundColor = UIColor.red
        countLabel.textColor = UIColor.white
        countLabel.textAlignment = .center
        countLabel.text = "0"
        countLabel.center = CGPoint(x: bottomView.bounds.width / 2, y: bottomView.bounds.height / 2)
        bottomView.addSubview(countLabel)
        
    }
    
    func setBottomButtons(_ title: String, center: CGPoint) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width / 3, height: viewHight - 10))
        button.center = center
        button.backgroundColor = UIColor.red
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        bottomView.addSubview(button)
        
        return button
    }
}

extension VideosManagerController {
    
    //获取截图
    func getVideoImages(_ urls: [String]) {
        
        DispatchQueue.global().async {
            for item in urls {
                let videoAsset = AVURLAsset(url: URL(fileURLWithPath: item))
                let cmTime = CMTime(seconds: 1, preferredTimescale: 10)
                let imageGenerator = AVAssetImageGenerator(asset: videoAsset)
                if let cgImage = try? imageGenerator.copyCGImage(at: cmTime, actualTime: nil) {
                    let image = UIImage(cgImage: cgImage)
                    self.allImageArray.append(image)
                } else {
                    print("获取缩略图失败")
                }
                DispatchQueue.main.async {
                    self.collectonView.reloadData()
                }
            }
        }
    }
    
    @objc func chooseButtonAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        showBottomView(button.isSelected)
        
        handleChooseAction(button.isSelected)
    }
    
    func handleChooseAction(_ isChoose: Bool) {
        videoIsSelected = isChoose
        operatorVideosArray.removeAll()
        if videoIsSelected {
            for i in 0 ..< nsnumberArray.count {
                nsnumberArray[i] = 0
            }
        } else {
            for i in 0 ..< nsnumberArray.count {
                nsnumberArray[i] = 1
            }
        }
        collectonView.reloadData()
    }
    
    @objc func uploadAction() {
        
    }
    
    @objc func deleteAction() {
        //  删除本地文件
        for item in operatorVideosArray {
            do {
                try FileManager.default.removeItem(atPath: item)
            } catch let error as NSError {
                print("删除失败: \(error)")
            }
        }
        
        //  删除界面元素
        for index in 0 ..< operatorVideosArray.count {
            let img = operatorVideosImage[index]
            let currentIndex = allImageArray.index(of: img)
            allImageArray.remove(at: currentIndex!)
        }
        
        //  重新解析地址
        allVideosPaths.removeAll()
        operatorVideosImage.removeAll()
        allVideosPaths = getAllVideoPaths()
        
        operatorVideosArray.removeAll()
        countLabel.text = "0"
        
        handleChooseAction(true)
        
    }
    
    //  是否展示下面的操作按钮
    func showBottomView(_ isShow: Bool) {
        if isShow {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
                self.bottomView.frame.origin.y -= self.viewHight
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomView.frame.origin.y += self.viewHight
            })
        }
    }
}
