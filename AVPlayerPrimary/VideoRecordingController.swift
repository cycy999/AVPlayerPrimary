//
//  VideoRecordingController.swift
//  AVPlayerPrimary
//
//  Created by 陈岩 on 2018/3/22.
//  Copyright © 2018年 陈岩. All rights reserved.
//

import UIKit
import AVFoundation

class VideoRecordingController: UIViewController {

    let maxVideoRecordTime = 6000
    
    let captureSession = AVCaptureSession()
    
    var camera: AVCaptureDevice?
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var headerView: UIView!
    
    let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    
    let fileOut = AVCaptureMovieFileOutput()
    
    var startButton: UIButton!
    var stopButton: UIButton!
    
    var cameraSideButton: UIButton!
    var flashLightButton: UIButton!
    
    var totoaTimeLabel: UILabel!
    var timer: Timer?
    var secondCount = 0
    
    var operatorView: VideoOperatorView!
    
    var isRecording = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setupAVFoundationSettings()
        
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
    
    func setupAVFoundationSettings() {
        camera = cameraWithPosition(AVCaptureDevice.Position.back)
        
        captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480
        
        if let videoInput = try? AVCaptureDeviceInput(device: self.camera!) {
            self.captureSession.addInput(videoInput)
        }
        
        if let audioInput = try? AVCaptureDeviceInput(device: self.audioDevice!) {
            self.captureSession.addInput(audioInput)
        }
        
        self.captureSession.addOutput(fileOut)
        
        let videoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.frame = view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
        
        previewLayer = videoLayer
        self.captureSession.startRunning()
        
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
    
    @objc func onClickStartButton(_ sender: UIButton) {
        hiddenHeaderView(true)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(videoRecordTotalTime), userInfo: nil, repeats: true)
        
        if !isRecording {
            isRecording = true
            
            captureSession.startRunning()
            
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentPath = path[0]
            let s = String(describing: Date())
            let filePath = documentPath + "/\(s).mp4"
            let fileUrl = URL(fileURLWithPath: filePath)
            fileOut.startRecording(to: fileUrl, recordingDelegate: self)
            
            startButton.backgroundColor = UIColor.lightGray
            startButton.isUserInteractionEnabled = false
            stopButton.backgroundColor = UIColor.red
            stopButton.isUserInteractionEnabled = true
            
        }
    }
    
    @objc func onClickEndButton(_ sender: UIButton) {
        hiddenHeaderView(false)
        
        timer?.invalidate()
        timer = nil
        
        secondCount = 0
        
        if isRecording {
            captureSession.stopRunning()
            
            isRecording = false
            
            startButton.backgroundColor = UIColor.red
            startButton.isUserInteractionEnabled = true
            stopButton.backgroundColor = UIColor.lightGray
            stopButton.isUserInteractionEnabled = false
            
        }
        
        operatorView = VideoOperatorView(frame: CGRect(x: 0, y: DEVICE_HEIGHT, width: DEVICE_WIDTH, height: DEVICE_HEIGHT))
        view.addSubview(operatorView)
        operatorView.controller = self
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20, options: UIViewAnimationOptions(), animations: {
            self.operatorView.frame.origin.y = 0
        }, completion: nil)
        
        
    }
    
    @objc func changeCamera(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        captureSession.stopRunning()
        
        
    }
    
    @objc func swithFlashLight(_ sender: UIButton) {
        
    }
    
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
}

extension VideoRecordingController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        self.operatorView.url = outputFileURL
    }
    
    
}
