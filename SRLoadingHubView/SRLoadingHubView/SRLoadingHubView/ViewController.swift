//
//  ViewController.swift
//  SRLoadingHubView
//
//  Created by 潘东 on 2016/9/28.
//  Copyright © 2016年 潘东. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let hud = SRLoadingHubView(frame: CGRect(x: 85, y: 80, width: 150, height: 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(hud)
        self.view.backgroundColor = UIColor.gray
        hud.ballColor = UIColor.black
        
        let bt1 = UIButton(frame: CGRect(x: 100, y: 50, width: 20, height: 20))
        bt1.backgroundColor = UIColor.red
        bt1.addTarget(self, action: #selector(ViewController.showHub), for: .touchUpInside)
        self.view.addSubview(bt1)
        
        let bt = UIButton(frame: CGRect(x: 50, y: 50, width: 20, height: 20))
        bt.backgroundColor = UIColor.blue
        bt.addTarget(self, action: #selector(ViewController.dismissHub), for: .touchUpInside)
        self.view.addSubview(bt)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showHub() {
        hud.showHub()
    }
    
    func dismissHub() {
        hud.dismissHub()
    }
}

