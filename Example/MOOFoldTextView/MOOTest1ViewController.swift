//
//  MOOTest1ViewController.swift
//  MOOFoldTextView_Example
//
//  Created by mikimo on 2023/11/19.
//  Copyright © 2023 Mobi Technology  All rights reserved.
//

import UIKit
import MOOFoldTextView

class MOOTest1ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Test1"
        // 2.1
        self.view.addSubview(self.mooFoldTextView)
        // 2.2 set config and reload
        self.mooFoldTextView.mooConfig = self.mooFoldTextConfig
        self.mooFoldTextView.mooReloadText()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // 3
        self.mooFoldTextView.frame = CGRect(x: 0.0,
                                            y: 100.0,
                                            width: CGRectGetWidth(self.view.bounds),
                                            height: self.mooFoldTextConfig.currentHeight())
    }
    
    // 1.1 init view
    private lazy var mooFoldTextView: MOOFoldTextView = {
        let view = MOOFoldTextView(frame: .zero)
        view.backgroundColor = .cyan
        view.mooDelegate = self
        return view
    }()
    
    // 1.2 init conifg
    private lazy var mooFoldTextConfig: MOOFoldTextConfig = {
        let config = MOOFoldTextConfig()
        config.allText =
        """
        Swift is a type-safe language, which means the language helps you to be clear about\
         the types of values your code can work with. If part of your code requires a String,\
        type safety prevents you from passing it an Int by mistake. Likewise, type safety\
        prevents you from accidentally passing an optional String
        """
        config.paragraph.lineSpacing = 10.0
        config.contentWidth = CGRectGetWidth(self.view.bounds)
        return config
    }()
}

// 4 Implement Proxy
extension MOOTest1ViewController: MOOFoldTextViewDelegate {
    
    func mooFoldViewShouldUpdateLayout(_ foldTextView: MOOFoldTextView) {
        // update layout after fold state changed
        self.view.setNeedsLayout()
    }
}
