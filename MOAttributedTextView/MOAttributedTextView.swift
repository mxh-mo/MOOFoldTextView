//
//  MOAttributedTextView.swift
//  MOAttributedTextView
//
//  Created by 莫小言 on 2020/12/3.
//
// All properties and methods should be prefixed with the library name to prevent future conflicts with the system
// Prefix with `mo / MO` are public
// Prefix with `mo_` are private

import UIKit

protocol MOAttributedTextViewDelegate {
    func moTextViewHeight(_ isOpen: Bool, _ height: CGFloat)
}

final class MOAttributedTextView: UITextView {
    var moDelegate: MOAttributedTextViewDelegate?
    var moAllText: String = ""
    var moLessLine: Int = 3 // rows for close status
    var moOpenText: String = "More"
    var moCloseText: String = "Close"
    var moAttributs: [NSAttributedString.Key : Any] = [:]
    var moParagraph: NSMutableParagraphStyle = NSMutableParagraphStyle()
    
    // need set frame.size.width, the height will be calculated according to this width
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        // some default set (you can modified as situation)
        self.textContainer.lineFragmentPadding = 0 // clear side margin
        textContainerInset = .zero // clear inset
        isEditable = false // disable edit, otherwise click will pop up the keyboard
        isScrollEnabled = false // disable scroll
        delegate = self
    }
    
    // above properties shoud modified before call this method
    public func moReloadTextView() {
        mo_calculateSomething()
        mo_reloadText()
    }
    
    // according to set to show text
    private func mo_reloadText() {
        if mo_isOpen && mo_allLine > moLessLine {
            mo_openTextAction()
        } else {
            mo_closeTextAction()
        }
    }
    
    // MARK: - Open text
    private func mo_openTextAction() {
        let result = moAllText + moCloseText
        // set attributs and pargrapgStyle for attributedString
        let attributedString = NSMutableAttributedString(string: result, attributes: moAttributs)
        attributedString.addAttribute(.paragraphStyle, value: moParagraph, range: NSRange(location: 0, length: moAllText.count))
        // add tap action for link range
        let linkRange = NSRange(location: result.count - moCloseText.count, length: moCloseText.count)
        attributedString.addAttribute(.link, value: kMoClickUrlString, range: linkRange)
        attributedText = attributedString
        // notify delegate
        moDelegate?.moTextViewHeight(mo_isOpen, mo_openHeight)
    }
    
    // MARK: - Close text
    private func mo_closeTextAction() {
        // get the previese lessline string
        let preLessLineText = mo_preLessLineString()
        // cut the same text as openText, then + openText
        let startIndex = preLessLineText.index(preLessLineText.endIndex, offsetBy: -moOpenText.count)
        let endIndex = preLessLineText.endIndex
        let range = startIndex ..< endIndex
        let needShowText = preLessLineText.replacingCharacters(in: range, with: moOpenText)
        // set attributs and pargrapgStyle for attributedString
        let attributedString = NSMutableAttributedString(string: needShowText, attributes: moAttributs)
        attributedString.addAttribute(.paragraphStyle, value: moParagraph, range: NSRange(location: 0, length: needShowText.count))
        // add tap action for link range
        let linkRange = NSRange(location: needShowText.count - moOpenText.count, length: moOpenText.count)
        attributedString.addAttribute(.link, value: kMoClickUrlString, range: linkRange)
        attributedText = attributedString
        // notify delegate
        moDelegate?.moTextViewHeight(mo_isOpen, mo_closeHeight)
    }
    
    // MARK: - calculate some propertys
    private func mo_calculateSomething() {
        // set font and text
        mo_font = moAttributs[.font] as? UIFont ?? .systemFont(ofSize: 16)
        font = mo_font
        mo_lineHeight = moParagraph.lineSpacing + mo_font.lineHeight
        mo_closeHeight = CGFloat(moLessLine) * mo_lineHeight
        text = moAllText + moCloseText
        // get height according font and width
        let height = sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        // get line number according height and lineHeight
        mo_allLine = Int(floor(height / mo_font.lineHeight))
        mo_openHeight = CGFloat(mo_allLine) * mo_lineHeight
    }
    
    // MARK: - get the first less lines of string
    private func mo_preLessLineString() -> String {
        let attributedString = NSMutableAttributedString(string: moAllText, attributes: moAttributs)
        let ctFrameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        // here add 8 spacing to width for calculate
        let containerFrame = CGRect(x: 0, y: 0, width: frame.size.width-8, height: CGFloat.greatestFiniteMagnitude)
        let path = CGPath(rect: containerFrame, transform: nil)
        let ctFrame = CTFramesetterCreateFrame(ctFrameSetter, CFRange(location: 0, length: 0), path, nil)
        let lines: NSArray = CTFrameGetLines(ctFrame)
        // length of the first less lines
        var preLessLineLength = 0.0
        for i in 0..<moLessLine {
            let lineRange = CTLineGetStringRange(lines[i] as! CTLine)
            preLessLineLength += Double(lineRange.length)
        }
        // get the first less lines of string
        let index = moAllText.index(moAllText.startIndex, offsetBy: String.IndexDistance(preLessLineLength))
        let lineString = moAllText[...index]
        return String(lineString)
    }
    private var mo_font: UIFont = .systemFont(ofSize: 16)
    private var mo_isOpen: Bool = false
    private var mo_allLine: Int = 0
    private var mo_lineHeight: CGFloat = 0.0
    private var mo_closeHeight: CGFloat = 0.0
    private var mo_openHeight: CGFloat = 0.0
    private let kMoClickUrlString: String = "com.mxh.mxhTextView.isOpen"
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// If other agents need to be implemented, they can be forwarded here
extension MOAttributedTextView: UITextViewDelegate {
    // MARK: - click textView link range
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == kMoClickUrlString { // click open / close
            mo_isOpen = !mo_isOpen
            mo_reloadText()
            return false
        }
        return true
    }
}
