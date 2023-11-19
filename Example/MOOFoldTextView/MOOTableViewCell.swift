//
//  MOOTableViewCell.swift
//  MOOFoldTextView_Example
//
//  Created by mikimo on 2023/11/19.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import MOOFoldTextView

// 3.1
public protocol MOOTableViewCellDelegate: AnyObject {
    func mooCellShouldReloadData(_ cell: UITableViewCell)
}

class MOOTableViewCell: UITableViewCell {

    // 2
    var mooConfig: MOOFoldTextConfig = MOOFoldTextConfig() {
        didSet {
            self.attributeTextView.mooConfig = self.mooConfig
            self.attributeTextView.mooReloadText()
        }
    }
    // 3.2
    weak var mooDelegate: MOOTableViewCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 1.2 add to super view
        self.contentView.addSubview(self.attributeTextView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 1.3 set frame
        self.attributeTextView.frame = self.contentView.bounds
    }
    
    // 1.1 init
    private lazy var attributeTextView: MOOFoldTextView = {
        let view = MOOFoldTextView(frame: .zero)
        view.backgroundColor = .cyan
        view.mooDelegate = self
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 3.3
extension MOOTableViewCell: MOOFoldTextViewDelegate {
    func mooFoldViewShouldUpdateLayout(_ foldTextView: MOOFoldTextView) {
        self.mooDelegate?.mooCellShouldReloadData(self)
    }
}
