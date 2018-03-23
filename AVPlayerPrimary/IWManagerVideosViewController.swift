//
//  IWManagerVideosViewController.swift
//  AVPlayerPrimary
//
//  Created by 陈岩 on 2018/3/23.
//  Copyright © 2018年 陈岩. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class IWManagerVideosViewController: UIViewController,
    UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource {
    
    //  MARK: - Static constant
    fileprivate let Margin:CGFloat = 5
    fileprivate let ViewHeight:CGFloat = 50
    fileprivate let cellIdentifier = "videoCell"
    
    //  MARK: - Properties
    //  所有视频完整路径
    fileprivate var allVideosHolePaths: [String]?
    fileprivate var allImageArray = [UIImage]()
    //  表示是否被选中的数组
    fileprivate var nsnumberArray = [NSNumber]()
    //  载体 collectionView
    fileprivate var videosCollectionView: UICollectionView?
    //  视频是否处于可选择状态
    fileprivate var videoIsSelectedAble = false
    //  操作数组
    fileprivate var operatorVideosArray = [String]()
    //  选中cell的图片
    fileprivate var operatorVideosImage = [UIImage]()
    //  上传、删除按钮
    fileprivate var bottomView: UIView?
    //  操作数量Label
    fileprivate var countLabel = UILabel()
    
    
    //  MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视频管理"
        //  获取全部本地视频路径
        allVideosHolePaths = getAllVideoPaths()
        
        //  collectionView
        videosCollectionView = prepareCollectionView()
        
        //  添加选择按钮
        addChooseButton()
        
        //  添加操作视图
        addBottomView()
        
        //  获取截图
        getVideoImages(allVideosHolePaths!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK: - Private Methods
    /**
     获取全部视频了路径
     
     - returns: 路径数组
     */
    func getAllVideoPaths() -> [String] {
        var pathArray = [String]()
        //  Documents 文件夹
        let pathFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //  文件夹路径
        let pathString = pathFolder[0] as String
        //  拼接获取每一个文件的完整路径
        if let lists =  try? FileManager.default.contentsOfDirectory(atPath: pathString) {
            for item in lists {
                pathArray.append(pathString + "/" + item)
            }
        }
        
        //  添加标识数组
        for _ in pathArray {
            nsnumberArray.append(1)
        }
        
        return pathArray
    }
    
    /**
     添加 collectionView
     
     - returns: collectionVIew
     */
    func prepareCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.itemSize = CGSize(width: (view.bounds.width - 5 * Margin) / 4, height: (view.bounds.width - 5 * Margin) / 4)
        collectionView.contentInset = UIEdgeInsetsMake(Margin, Margin
            , Margin, Margin)
        flowLayout.minimumLineSpacing = Margin
        flowLayout.minimumInteritemSpacing = Margin
        
        collectionView.register(videoCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }
    
    /**
     添加选择按钮
     */
    func addChooseButton() {
        let chooseButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        chooseButton.setTitle("选择", for: UIControlState())
        chooseButton.setTitle("取消", for: .selected)
        chooseButton.setTitleColor(UIColor.blue, for: UIControlState())
        chooseButton.addTarget(self, action: #selector(chooseButtonAction(_:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: chooseButton)
    }
    
    /**
     底部操作视图
     */
    func addBottomView() {
        bottomView = UIView(frame: CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: ViewHeight))
        view.addSubview(bottomView!)
        
        let uploadBtn = setBottomButtons("上传", center: CGPoint(x: view.bounds.width / 4, y: ViewHeight / 2))
        let deleteBtn = setBottomButtons("删除", center: CGPoint(x: view.bounds.width * 3 / 4, y: ViewHeight / 2))
        
        uploadBtn.addTarget(self, action: #selector(uploadAction), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        //  数量
        countLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        countLabel.clipsToBounds = true
        countLabel.layer.cornerRadius = 15
        countLabel.backgroundColor = UIColor.red
        countLabel.textColor = UIColor.white
        countLabel.textAlignment = .center
        countLabel.text = "0"
        countLabel.center = CGPoint(x: bottomView!.bounds.width / 2, y: bottomView!.bounds.height / 2)
        bottomView?.addSubview(countLabel)
    }
    
    //  是否展示下面的操作安妮
    func showBottomView(_ isShow: Bool) {
        if isShow {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: {
                self.bottomView?.frame.origin.y -= self.ViewHeight
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomView?.frame.origin.y += self.ViewHeight
            })
        }
    }
    
    //  统一风格上传、删除按钮
    func setBottomButtons(_ title: String, center: CGPoint) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width / 3, height: ViewHeight - 10))
        button.center = center
        button.backgroundColor = UIColor.red
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        bottomView?.addSubview(button)
        
        return button
    }
    
    //  删除事件
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
        allVideosHolePaths?.removeAll()
        operatorVideosImage.removeAll()
        allVideosHolePaths = getAllVideoPaths()
        
        operatorVideosArray.removeAll()
        countLabel.text = "0"
        
        //  刷新
        handleChooseAction(true)
    }
    //  上传事件
    @objc func uploadAction() {
        
    }
    
    //  点击选择按钮事件
    @objc func chooseButtonAction(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        showBottomView(btn.isSelected)
        
        handleChooseAction(btn.isSelected)
    }
    //  处理
    func handleChooseAction(_ isChoose: Bool) {
        videoIsSelectedAble = isChoose
        operatorVideosArray.removeAll()
        if videoIsSelectedAble {
            for index in 0 ..< nsnumberArray.count {
                nsnumberArray[index] = 0
            }
        } else {
            for index in 0 ..< nsnumberArray.count {
                nsnumberArray[index] = 1
            }
        }
        
        videosCollectionView?.reloadData()
        
    }
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
    func getVideoImages(_ videoUrls: [String]) {
        
        //  获取截图
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            for item in videoUrls {
                let videoAsset = AVURLAsset(url: URL(fileURLWithPath: item))
                let cmTime = CMTime(seconds: 1, preferredTimescale: 10)
                let imageGenerator = AVAssetImageGenerator(asset: videoAsset)
                if let cgImage = try? imageGenerator.copyCGImage(at: cmTime, actualTime: nil) {
                    let image = UIImage(cgImage: cgImage)
                    self.allImageArray.append(image)
                } else {
                    print("获取缩略图失败")
                }
            }
            DispatchQueue.main.async(execute: {
                self.videosCollectionView?.reloadData()
            })
        })
        
    }
    
    // MARK: -  CollectionView delegate / dataSouorce
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allVideosHolePaths!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! videoCollectionViewCell
        
        if  allVideosHolePaths?.count == allImageArray.count {
            cell.videoInterface?.image = allImageArray[indexPath.row]
        }
        
        //  蒙版状态
        if videoIsSelectedAble {
            //  确认选中状态
            
            cell.selectedButton.isHidden = false
            cell.videoIsChooose = nsnumberArray[indexPath.row] as! Bool
        } else {
            cell.selectedButton.isHidden = true
            cell.videoIsChooose = nsnumberArray[indexPath.row] as! Bool
        }
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! videoCollectionViewCell
        guard videoIsSelectedAble else{
            //  不可选择，点击预览
            let player = AVPlayer.init(url: URL(fileURLWithPath: allVideosHolePaths![indexPath.row]))
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true, completion: nil)
            return
        }
        
        //  可选择
        cell.videoIsChooose = !cell.videoIsChooose!
        
        if cell.videoIsChooose == true {
            operatorVideosArray.append(allVideosHolePaths![indexPath.row])
            operatorVideosImage.append(allImageArray[indexPath.row])
        } else {
            let index = operatorVideosArray.index(of: allVideosHolePaths![indexPath.row])
            operatorVideosArray.remove(at: index!)
            operatorVideosImage.remove(at: index!)
        }
        
        countLabel.text = "\(operatorVideosArray.count)"
        
        nsnumberArray[indexPath.row] = cell.videoIsChooose! as NSNumber
        
    }
}


//  MARK: - Define Cell
class videoCollectionViewCell: UICollectionViewCell {
    
    //  封面
    var videoInterface: UIImageView?
    //  蒙版
    var effectView = UIVisualEffectView()
    //  是否选中图标
    var selectedButton = UIButton()
    
    var videoIsChooose: Bool? {
        willSet {
            selectedButton.isSelected = newValue!
            if newValue == true {
                effectView.alpha = 0
            } else {
                effectView.alpha = 0.4
            }
        }
    }
    
    //  初始化调用方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        videoIsChooose = false
        self.backgroundColor = UIColor.groupTableViewBackground
        
        makeInterfaceImage()
    }
    
    // 添加封面
    func makeInterfaceImage() {
        videoInterface = UIImageView(frame: self.contentView.bounds)
        self.contentView.addSubview(videoInterface!)
        
        //  添加图标
        let playIconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        playIconImageView.image = UIImage(named: "iw_playIcon")
        playIconImageView.center = CGPoint(x: videoInterface!.bounds.width / 2, y: videoInterface!.bounds.height / 2)
        videoInterface?.addSubview(playIconImageView)
        
        //  添加是否选中图标
        selectedButton.frame =  CGRect(x: 3, y: 3, width: 20, height: 20)
        selectedButton.setBackgroundImage(UIImage(named: "iw_unselected"), for: UIControlState())
        selectedButton.setBackgroundImage(UIImage(named: "iw_selected"), for: .selected)
        videoInterface?.addSubview(selectedButton)
        selectedButton.isHidden = true
        
        //  添加蒙版
        effectView.frame = videoInterface!.bounds
        effectView.effect = UIBlurEffect(style: .dark)
        effectView.alpha = 0.0
        videoInterface?.addSubview(effectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

