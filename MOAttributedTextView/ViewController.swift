//
//  ViewController.swift
//  MOAttributedTextView
//
//  Created by 莫小言 on 2020/12/3.
//

import UIKit

class ViewController: UIViewController, MOAttributedTextViewDelegate {
    
    var moTextView: MOAttributedTextView = MOAttributedTextView(frame: CGRect(x: 20, y: 100, width: 300, height: 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font: UIFont = .systemFont(ofSize: 16)
        let allText = "Swift is a type-safe language, which means the language helps you to be clear about the types of values your code can work with. If part of your code requires a String, type safety prevents you from passing it an Int by mistake. Likewise, type safety prevents you from accidentally passing an optional String"
        
        let attributs: [NSAttributedString.Key : Any] = [
          .foregroundColor: UIColor.black,
          .font: font
        ]
        let pargraphStyle = NSMutableParagraphStyle()
        pargraphStyle.lineSpacing = 10
        
        // example
        moTextView.moDelegate = self
        moTextView.moLessLine = 3 // defaut：3
        moTextView.moAllText = allText
        moTextView.moOpenText = "More" // defaut：More
        moTextView.moCloseText = "Close" // defaut：Close (if not, set "")
        moTextView.moAttributs = attributs // font defaut：.systemFont(ofSize: 16)
        moTextView.moParagraph = pargraphStyle // defaut：NSMutableParagraphStyle()
        moTextView.backgroundColor = .cyan
        moTextView.moReloadTextView()
        view.addSubview(moTextView)
    }
    
    // MARK: - MOAttributedTextViewDelegate
    func moTextViewHeight(_ isOpen: Bool, _ height: CGFloat) {
        self.moTextView.frame = CGRect(x: 20, y: 100, width: 300, height: height)
    }
}


// 参考：iOS 富文本添加点击事件 https://www.jianshu.com/p/480db0cc7380
// 参考：Ranges in Swift explained with code examples https://www.avanderlee.com/swift/ranges-explained/
// 参考：ios获取UILabel每行显示的文字 https://www.jianshu.com/p/65a07b6013c7
