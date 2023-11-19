//
//  ViewController.swift
//  MOOFoldTextView
//
//  Created by mikimo on 11/19/2023.
//  Copyright (c) 2023 Mobi Technology All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. textView 内部交互控制 显示 or 收起
        let test1Btn = UIButton(type: .custom)
        test1Btn.setTitle("Test1", for: .normal)
        test1Btn.setTitleColor(.white, for: .normal)
        test1Btn.frame = CGRect(x: 20, y: 100, width: 60, height: 44)
        test1Btn.addTarget(self, action: #selector(clickTest1Btn), for: .touchUpInside)
        test1Btn.backgroundColor = .red
        view.addSubview(test1Btn)
        
        // 2. 先计算出高度 外包设置 显示 or 收起 (方便UITableViewCell里使用)
        let test2Btn = UIButton(type: .custom)
        test2Btn.setTitle("Test2", for: .normal)
        test2Btn.setTitleColor(.white, for: .normal)
        test2Btn.frame = CGRect(x: 100, y: 100, width: 60, height: 44)
        test2Btn.addTarget(self, action: #selector(clickTest2Btn), for: .touchUpInside)
        test2Btn.backgroundColor = .red
        view.addSubview(test2Btn)
    }
    
    @objc func clickTest1Btn() {
        self.navigationController?.pushViewController(MOOTest1ViewController(), animated: true)
    }
    
    @objc func clickTest2Btn() {
        self.navigationController?.pushViewController(MOOTest2ViewController(), animated: true)
    }
}

