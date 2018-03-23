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
    //  MARK: - Properties
    //  所有视频完整路径
    var allVideoPaths = [String]()
    var allVideoImages = [UIImage]()
    
    //  表示是否被选中的数组
    var nsnumberArray = [NSNumber]()
    
    var collectonView: UICollectionView!
    
    //  视频是否处于可选择状态
    var videoIsSelected = false
    
    //  操作数组
    var operatorVideoPaths = [String]()
    //  选中cell的图片
    var operatorVideoImages = [UIImage]()
    //  上传、删除按钮
    var bottomView: UIView!
    //  操作数量Label
    var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  获取全部本地视频路径
        allVideoPaths = getAllVideoPaths()
        
        collectonView = config_collection()
        
        config_button()        //  添加选择按钮
        
        config_bottomView()
        
        getVideoImages(allVideoPaths)        //  获取截图
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}


extension VideosManagerController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allVideoPaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCollectionCell
        
        if allVideoPaths.count == allVideoImages.count {
            cell.videoInterface.image = allVideoImages[indexPath.row]
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
            let player = AVPlayer.init(url: URL(fileURLWithPath: allVideoPaths[indexPath.row]))
            print(allVideoPaths[indexPath.row])
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true, completion: nil)
            return
        }
        
        //  可选择
        cell.videoIsChoose = !cell.videoIsChoose
        
        if cell.videoIsChoose == true {
            operatorVideoPaths.append(allVideoPaths[indexPath.row])
            operatorVideoImages.append(allVideoImages[indexPath.row])
        } else {
            let index = operatorVideoPaths.index(of: allVideoPaths[indexPath.row])
            operatorVideoPaths.remove(at: index!)
            operatorVideoImages.remove(at: index!)
        }
        
        countLabel.text = "\(operatorVideoPaths.count)"
        
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
    
    //  通过文件路径获取截图:
    func getVideoImage(_ videoUrl: URL) -> UIImage? {
        //  获取截图
        let videoAsset = AVURLAsset(url: videoUrl)
        let cmTime = CMTime(seconds: 1, preferredTimescale: 10)
        let imageGenerator = AVAssetImageGenerator(asset: videoAsset)
        if let cgImage = try? imageGenerator.copyCGImage(at: cmTime, actualTime: nil) {
            let image = UIImage(cgImage: cgImage)
            return image
        } else {
            print("获取缩略图失败")
        }
        
        return nil
    }
    
    //  通过文件路径获取截图:
    func getVideoImages(_ urls: [String]) {
        
        DispatchQueue.global().async {
            for item in urls {
                let videoAsset = AVURLAsset(url: URL(fileURLWithPath: item))
                let cmTime = CMTime(seconds: 1, preferredTimescale: 10)
                let imageGenerator = AVAssetImageGenerator(asset: videoAsset)
                if let cgImage = try? imageGenerator.copyCGImage(at: cmTime, actualTime: nil) {
                    let image = UIImage(cgImage: cgImage)
                    self.allVideoImages.append(image)
                } else {
                    print("获取缩略图失败")
                }
                DispatchQueue.main.async {
                    self.collectonView.reloadData()
                }
            }
        }
    }
    
    //  点击选择按钮事件
    @objc func chooseButtonAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        showBottomView(button.isSelected)
        
        handleChooseAction(button.isSelected)
    }
    
    func handleChooseAction(_ isChoose: Bool) {
        videoIsSelected = isChoose
        operatorVideoPaths.removeAll()
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
        for item in operatorVideoPaths {
            do {
                try FileManager.default.removeItem(atPath: item)
            } catch let error as NSError {
                print("删除失败: \(error)")
            }
        }
        
        //  删除界面元素
        for index in 0 ..< operatorVideoPaths.count {
            let img = operatorVideoImages[index]
            let currentIndex = allVideoImages.index(of: img)
            allVideoImages.remove(at: currentIndex!)
        }
        
        //  重新解析地址
        allVideoPaths.removeAll()
        operatorVideoImages.removeAll()
        allVideoPaths = getAllVideoPaths()
        
        operatorVideoPaths.removeAll()
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
