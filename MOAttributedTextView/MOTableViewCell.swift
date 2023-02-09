//
//  MOTableViewCell.swift
//  MOAttributedTextView
//
//  Created by 莫晓卉 on 2020/12/6.
//

import UIKit
import SnapKit

// 3.1 Agents out click event
protocol MOTableViewCellDelegate {
    func tapTextViewCell(_ isOpen: Bool)
}

final class MOTableViewCell: UITableViewCell {
    
    // 1. just need to set frame.width
    private var moTextView: MOAttributedTextView = MOAttributedTextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 30, height: 0))
    var allText: String = "" {
        didSet {
            moTextView.moAllText = allText
            moTextView.moReloadTextView()
        }
    }
    // 3.2
    var delegate: MOTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .gray
        // 2. Set some parameters as required
        let font: UIFont = .systemFont(ofSize: 16)
        let attributs: [NSAttributedString.Key : Any] = [
          .foregroundColor: UIColor.black,
          .font: font
        ]
        let pargraphStyle = NSMutableParagraphStyle()
        pargraphStyle.lineSpacing = 10
        moTextView.moLessLine = 3 // defaut：3
        moTextView.moAllText = allText
        moTextView.moOpenText = "More" // defaut：More
        moTextView.moCloseText = "Close" // defaut：Close (if not, set "")
        moTextView.moAttributs = attributs // font defaut：.systemFont(ofSize: 16)
        moTextView.moParagraph = pargraphStyle // defaut：NSMutableParagraphStyle()
        moTextView.moIsOpen = false
        moTextView.moDelegate = self
        moTextView.backgroundColor = .cyan
        contentView.addSubview(moTextView)
        moTextView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// 3.3
extension MOTableViewCell: MOAttributedTextViewDelegate {
    func moTapTextView(_ isOpen: Bool) {
        delegate?.tapTextViewCell(isOpen)
    }
}
