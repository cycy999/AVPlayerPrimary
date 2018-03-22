//
//  ViewController.swift
//  AVPlayerPrimary
//
//  Created by 陈岩 on 2018/3/22.
//  Copyright © 2018年 陈岩. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        button.center = CGPoint(x: DEVICE_WIDTH / 2, y: DEVICE_HEIGHT / 2)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
        view.addSubview(button)
        view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc func push() {
        //show(VideoRecordingController(), sender: nil)
        navigationController?.pushViewController(VideoRecordingController(), animated: true)
    }
    func getDeviceIP() {
        let ipUrl = URL.init(string: "http://pv.sohu.com/cityjson?ie=utf-8")
        if var needIP = try? String.init(contentsOf: ipUrl!, encoding: String.Encoding.utf8) {
            if needIP.hasPrefix("var returnCitySN = ") {
                for _ in 0 ..< 19 {
                    //needIP.remove(at: needIP.startIndex)
                }
                
                
            }
        }
        
        
        
    }
}

