//
//  MOTest1ViewController.swift
//  MOAttributedTextView
//
//  Created by 莫晓卉 on 2020/12/6.
//

import UIKit

class MOTest1ViewController: UIViewController, MOAttributedTextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Test1"
        test1()
    }
    
    // 1. just need to set frame.width
    var moTextView: MOAttributedTextView = MOAttributedTextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 0))

    func test1() {
        // 2. Set some parameters as required
        let font: UIFont = .systemFont(ofSize: 16)
        let allText =
            """
            Swift is a type-safe language, which means the language helps you to be clear about\
             the types of values your code can work with. If part of your code requires a String,\
            type safety prevents you from passing it an Int by mistake. Likewise, type safety\
            prevents you from accidentally passing an optional String
            """

        let attributs: [NSAttributedString.Key : Any] = [
          .foregroundColor: UIColor.black,
          .font: font
        ]
        let pargraphStyle = NSMutableParagraphStyle()
        pargraphStyle.lineSpacing = 10

        // example
        moTextView.moDelegate = self // follow the MOAttributedTextViewDelegate protocl
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
    
    // 3. Implementation protocol method, get height to refresh frame
    // MARK: - MOAttributedTextViewDelegate
    func moTextViewHeightChanged(_ height: CGFloat) {
        moTextView.frame = CGRect(x: 20, y: 100, width: UIScreen.main.bounds.width - 30, height: height)
    }

}
