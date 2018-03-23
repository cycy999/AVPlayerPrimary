//
//  VideoRecordingController.swift
//  AVPlayerPrimary
//
//  Created by 陈岩 on 2018/3/22.
//  Copyright © 2018年 陈岩. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

//在 Info.plist 配置请求摄像头、麦克风、相册权限的描述字段
//Privacy - Camera Usage Description
//Privacy - Microphone Usage Description
//Privacy - Photo Library Usage Description
class VideoRecordingController: UIViewController {

    //  最常视频录制时间，单位 秒
    let maxVideoRecordTime = 6000
    
    //  MARK: - Properties ，
    //  视频捕获会话，他是 input 和 output 之间的桥梁，它协调着 input 和 output 之间的数据传输
    let captureSession = AVCaptureSession()
    
    //  视频输入设备，前后摄像头
    var camera: AVCaptureDevice?
    
    //  展示界面
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var headerView: UIView!
    
    //  音频输入设备
    let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    
    //  将捕获到的视频输出到文件
    let fileOut = AVCaptureMovieFileOutput()
    
    //  开始、停止按钮
    var startButton: UIButton!
    var stopButton: UIButton!
    
    //  前后摄像头转换、闪光灯 按钮
    var cameraSideButton: UIButton!
    var flashLightButton: UIButton!
    
    //  录制时间 Label
    var totoaTimeLabel: UILabel!
    //  录制时间Timer
    var timer: Timer?
    var secondCount = 0
    
    //  视频操作View
    var operatorView: VideoOperatorView!
    
    //  表示当时是否在录像中
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        //  录制视频基本设置
        setupAVFoundationSettings()
        
        //  UI 布局
        setupButton()
        setupHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    
    
}

//MARK:  - UI
extension VideoRecordingController {
    
    
    func setupAVFoundationSettings() {
        camera = cameraWithPosition(AVCaptureDevice.Position.back)
        
        //  设置视频清晰度
        captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480
        
        //  添加视频、音频输入设备
        if let videoInput = try? AVCaptureDeviceInput(device: self.camera!) {
            self.captureSession.addInput(videoInput)
        }
        
        if let audioInput = try? AVCaptureDeviceInput(device: self.audioDevice!) {
            self.captureSession.addInput(audioInput)
        }
        
        //  添加视频捕获输出
        self.captureSession.addOutput(fileOut)
        
        //  使用 AVCaptureVideoPreviewLayer 可以将摄像头拍到的实时画面显示在 ViewController 上
        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.frame = view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
        
        previewLayer = videoLayer
        
        //  启动 Session 回话
        self.captureSession.startRunning()
        
    }
    
    func setupButton() {
        
        startButton = prepareButtons("开始", size: CGSize(width: 120, height: 50), center: CGPoint(x: DEVICE_WIDTH / 2 - 70, y: DEVICE_HEIGHT - 50))
        startButton.backgroundColor = UIColor.red
        startButton.addTarget(self, action: #selector(onClickStartButton(_:)), for: .touchUpInside)
        
        stopButton = prepareButtons("结束", size: CGSize(width: 120, height: 50), center: CGPoint(x: DEVICE_WIDTH / 2 + 70, y: DEVICE_HEIGHT - 50))
        stopButton.backgroundColor = UIColor.lightGray
        stopButton.isUserInteractionEnabled = true
        stopButton.addTarget(self, action: #selector(onClickEndButton(_:)), for: .touchUpInside)
    }
    
    func prepareButtons(_ title: String, size: CGSize, center: CGPoint) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        button.center = center
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(button)
        return button
    }
    
    func setupHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_WIDTH, height: 64))
        headerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.addSubview(headerView)
        
        let centerY = headerView.center.y + 5
        let width: CGFloat = 40
        
        //  返回、摄像头调整、时间、闪光灯四个按钮
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backButton.center = CGPoint(x: 25, y: centerY)
        backButton.setBackgroundImage(UIImage(named: "iw_back"), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        headerView.addSubview(backButton)
        
        cameraSideButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: width * 68 / 99))
        cameraSideButton.setBackgroundImage(UIImage(named: "iw_cameraSide"), for: .normal)
        cameraSideButton.center = CGPoint(x: 100, y: centerY)
        cameraSideButton.addTarget(self, action: #selector(changeCamera(_:)), for: .touchUpInside)
        headerView.addSubview(cameraSideButton)
        
        totoaTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        totoaTimeLabel.center = CGPoint(x: DEVICE_WIDTH / 2, y: centerY)
        totoaTimeLabel.textColor = UIColor.white
        totoaTimeLabel.textAlignment = .center
        totoaTimeLabel.font = UIFont.systemFont(ofSize: 19)
        totoaTimeLabel.text = "00:00:00"
        view.addSubview(totoaTimeLabel)
        
        flashLightButton = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: width * 68 / 99))
        flashLightButton.setBackgroundImage(UIImage(named: "iw_flashOn"), for: .selected)
        flashLightButton.setBackgroundImage(UIImage(named: "iw_flashOff"), for: .normal)
        flashLightButton.center = CGPoint(x: DEVICE_WIDTH - 100, y: centerY)
        flashLightButton.addTarget(self, action: #selector(swithFlashLight(_:)), for: .touchUpInside)
        headerView.addSubview(flashLightButton)
        
    }
    
    
    func hiddenHeaderView(_ bool: Bool) {
        if bool {
            UIView.animate(withDuration: 0.2, animations: {
                self.headerView.frame.origin.y -= 64
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.headerView.frame.origin.y += 64
            })
        }
    }
}

extension VideoRecordingController {
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //  MARK: - UIButton Actions
    //  按钮点击事件
    //  点击开始录制视频
    @objc func onClickStartButton(_ sender: UIButton) {
        hiddenHeaderView(true)
        
        //  开启计时器
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(videoRecordTotalTime), userInfo: nil, repeats: true)
        
        if !isRecording {
            //  记录状态： 录像中 ...
            isRecording = true
            
            captureSession.startRunning()
            //  设置录像保存地址，在 Documents 目录下，名为 当前时间.mp4

            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentPath = path[0]
            let s = String(describing: Date()).replacingOccurrences(of: " ", with: "")
            let filePath = documentPath + "/\(s).mp4"
            let fileUrl = URL(fileURLWithPath: filePath)
            
            //  启动视频编码输出
            fileOut.startRecording(to: fileUrl, recordingDelegate: self)
            
            //  开始、结束按钮改变颜色
            startButton.backgroundColor = UIColor.lightGray
            startButton.isUserInteractionEnabled = false
            stopButton.backgroundColor = UIColor.red
            stopButton.isUserInteractionEnabled = true
            
        }
    }
    
    //  点击停止按钮，停止了录像
    @objc func onClickEndButton(_ sender: UIButton) {
        hiddenHeaderView(false)
        //  关闭计时器
        timer?.invalidate()
        timer = nil
        
        secondCount = 0
        
        if isRecording {
            //  停止视频编码输出
            captureSession.stopRunning()
            //  记录状态： 录像结束 ...
            isRecording = false
            
            startButton.backgroundColor = UIColor.red
            startButton.isUserInteractionEnabled = true
            stopButton.backgroundColor = UIColor.lightGray
            stopButton.isUserInteractionEnabled = false
            
        }
        //  弹出View
        operatorView = VideoOperatorView(frame: CGRect(x: 0, y: DEVICE_HEIGHT, width: DEVICE_WIDTH, height: DEVICE_HEIGHT))
        view.addSubview(operatorView)
        operatorView.controller = self
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20, options: UIViewAnimationOptions(), animations: {
            self.operatorView.frame.origin.y = 0
        }, completion: nil)
        
        
    }
    
    //  调整摄像头
    @objc func changeCamera(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        captureSession.stopRunning()
        //  首先移除所有的 input
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
        
        changeCameraAnimate()
        //  添加音频输出
        if let andioInput = try? AVCaptureDeviceInput(device: self.audioDevice!) {
            self.captureSession.addInput(andioInput)
        }
        
        if cameraSideButton.isSelected {
            camera = cameraWithPosition(.front)
            if let input = try? AVCaptureDeviceInput(device: camera!) {
                captureSession.addInput(input)
            }
            
            if flashLightButton.isSelected {
                flashLightButton.isSelected = false
            }
        } else {
            camera = cameraWithPosition(.back)
            if let input = try? AVCaptureDeviceInput(device: camera!) {
                captureSession.addInput(input)
            }
        }
    }
    
    //  开启闪光灯
    @objc func swithFlashLight(_ sender: UIButton) {
        if self.camera?.position == AVCaptureDevice.Position.front {
            return
        }
        let camera = cameraWithPosition(.back)
        if camera?.torchMode == AVCaptureDevice.TorchMode.off {
            do {
                try camera?.lockForConfiguration()
            } catch let error as NSError {
                print("开启闪光灯失败：\(error)")
            }
            
            camera?.torchMode = AVCaptureDevice.TorchMode.on
            camera?.flashMode = AVCaptureDevice.FlashMode.on
            camera?.unlockForConfiguration()
            
            sender.isSelected = true
        } else {
            do {
                try camera?.lockForConfiguration()
            } catch let error as NSError {
                print("关闭闪光灯失败：\(error)")
            }
            
            camera?.torchMode = AVCaptureDevice.TorchMode.off
            camera?.flashMode = AVCaptureDevice.FlashMode.off
            camera?.unlockForConfiguration()
            
            sender.isSelected = false
            
        }
    }
    
    //  录制时间
    @objc func videoRecordTotalTime() {
        secondCount += 1
        
        if secondCount == maxVideoRecordTime {
            timer?.invalidate()
            let alert = UIAlertController(title: "只能录制十分钟", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        let hours = secondCount / 3600
        let mintues = (secondCount % 3600) / 60
        let seconds = secondCount % 60
        
        totoaTimeLabel.text = String(format: "%02d", hours) + ":" + String(format: "%02d", mintues) + ":" + String(format: "%02d", seconds)
    }
    
    func changeCameraAnimate() {
        let changeAnimate = CATransition()
        changeAnimate.delegate = self
        changeAnimate.duration = 0.4
        changeAnimate.type = "oglFlip"
        changeAnimate.subtype = kCATransitionFromRight
        previewLayer.add(changeAnimate, forKey: "changeAnimate")
    }
    
    //选择摄像头
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for item in devices {
            if item.position == position {
                return item
            }
        }
        return nil
    }
}

extension VideoRecordingController: AVCaptureFileOutputRecordingDelegate, CAAnimationDelegate {
    //  MARK: - 录像代理方法
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        self.operatorView.url = outputFileURL
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        captureSession.startRunning()
    }
    
}
