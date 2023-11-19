//
//  MOOFoldTextView.swift
//  MOOFoldTextView
//
//  Created by mikimo on 2023/11/19.
//  Copyright (c) 2023 Mobi Technology All rights reserved.
//
//  All properties and methods should be prefixed with the library name to prevent future conflicts with the system
//  Prefix with `moo / MOO` are public
//  Prefix with `moo_` are private

import UIKit

// MARK: - MOOFoldTextConfig
public class MOOFoldTextConfig {
    
    /// config base properties
    public var allText: String = ""
    public var contentWidth: CGFloat = 0.0
    public var foldLineCount: UInt = 3
    
    /// config text view style
    public var attributs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16.0)]
    public var paragraph: NSMutableParagraphStyle = NSMutableParagraphStyle()
    
    /// config text of unfold and fold text
    public var unfoldLinkText: String = "More"
    public var foldLinkText: String = "Close"
    
    /// will be set value after called calcParams()
    public private(set) var unfoldLineCount: UInt = 0
    public private(set) var unfoldHeight: CGFloat = 0.0
    public private(set) var foldHeight: CGFloat = 0.0
    
    /// will be set value from MOOFoldTextView, you shouldn't change value for this propery
    public var isUnFold: Bool = false

    public init() {
    }
    
    /// shoudl call after config properties changed
    public func calcHeight(_ textView: UITextView) {
        // set total text
        textView.attributedText = self.unfoldAttributeString()
        
        // get total height according width
        self.unfoldHeight = textView.sizeThatFits(CGSize(width: self.contentWidth,
                                                         height: CGFloat.greatestFiniteMagnitude)).height
        
        // get line number according height and lineHeight
        self.unfoldLineCount = UInt(floor(self.unfoldHeight / self.mooLineHeight()))
        
        // get close height
        if self.unfoldLineCount > self.foldLineCount {
            self.foldHeight = CGFloat(self.foldLineCount) * self.mooLineHeight()
        } else {
            self.foldHeight = self.unfoldHeight
        }
    }
    
    public func currentHeight() -> CGFloat {
        if self.isUnFold {
            return self.unfoldHeight
        } else {
            return self.foldHeight
        }
    }
    
    public func foldAttributeString() -> NSMutableAttributedString {
        // get the previese lessline string
        let preLessLineText = moo_preLessLineString()
        
        // cut the same text as unfoldLinkText, then + unfoldLinkText
        let startIndex = preLessLineText.index(preLessLineText.endIndex,
                                               offsetBy: -(unfoldLinkText.count + 2))
        let endIndex = preLessLineText.endIndex
        let range = startIndex ..< endIndex
        let needShowText = preLessLineText.replacingCharacters(in: range, with: " " + unfoldLinkText)
        
        // set attributs and pargrapgStyle for attributedString
        let attributedString = NSMutableAttributedString(string: needShowText,
                                                         attributes: attributs)
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraph,
                                      range: NSRange(location: 0, length: needShowText.count))
        
        // add tap action for link range
        let linkRange = NSRange(location: needShowText.count - unfoldLinkText.count,
                                length: unfoldLinkText.count)
        attributedString.addAttribute(.link,
                                      value: MOOUnfoldLinkScheme,
                                      range: linkRange)
        return attributedString
    }
    
    public func unfoldAttributeString() -> NSMutableAttributedString {
        let result = allText + " " + foldLinkText
        
        // set attributs and pargrapgStyle for attributedString
        let attributedString = NSMutableAttributedString(string: result,
                                                         attributes: attributs)
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraph,
                                      range: NSRange(location: 0, length: allText.count))
        
        // add tap action for link range
        let linkRange = NSRange(location: result.count - foldLinkText.count,
                                length: foldLinkText.count)
        attributedString.addAttribute(.link,
                                      value: MOOFoldLinkScheme,
                                      range: linkRange)
        return attributedString
    }
    
    // MARK: - Private Methods
    
    private func mooLineHeight() -> CGFloat {
        let font = attributs[.font] as? UIFont ?? .systemFont(ofSize: 16.0)
        return paragraph.lineSpacing + font.lineHeight
    }
    
    /// get the first less lines of string
    private func moo_preLessLineString() -> String {
        let attributedString = NSMutableAttributedString(string: allText, attributes: attributs)
        let ctFrameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        
        // here add 8 spacing to width for calculate
        let containerFrame = CGRect(x: 0.0,
                                    y: 0.0,
                                    width: contentWidth - 8.0,
                                    height: CGFloat.greatestFiniteMagnitude)
        let path = CGPath(rect: containerFrame, transform: nil)
        let ctFrame = CTFramesetterCreateFrame(ctFrameSetter, CFRange(location: 0, length: 0), path, nil)
        let lines: NSArray = CTFrameGetLines(ctFrame)
        
        // length of the first less lines
        var preLessLineLength = 0.0
        for i in 0..<foldLineCount {
            let lineRange = CTLineGetStringRange(lines[Int(i)] as! CTLine)
            preLessLineLength += Double(lineRange.length)
        }
        
        // get the first less lines of string
        let index = allText.index(allText.startIndex,
                                  offsetBy: Int(preLessLineLength))
        let lineString = allText[...index]
        return String(lineString)
    }
    
    public let MOOUnfoldLinkScheme: String = "com.mxh.mooFoldTextView.unfold"
    public let MOOFoldLinkScheme: String = "com.mxh.mooFoldTextView.fold"
}

public protocol MOOFoldTextViewDelegate: AnyObject {
    /// superView should setNeedLayout
    /// tableView should reloadData
    func mooFoldViewShouldUpdateLayout(_ foldTextView: MOOFoldTextView)
}

// MARK: - MOOFoldTextView
public class MOOFoldTextView: UITextView {
    
    public var mooConfig: MOOFoldTextConfig = MOOFoldTextConfig()
    public weak var mooDelegate: MOOFoldTextViewDelegate?
    
    /// should Call after config changed
    public func mooReloadText() {
        self.mooConfig.calcHeight(self)
        if self.moo_canUnfold() {
            self.mooUpdateToCloseState()
        } else {
            self.mooUpdateToOpenState()
        }
    }
    /// call to change to fold state
    public func mooUpdateToCloseState() {
        self.attributedText = self.mooConfig.foldAttributeString()
        self.mooConfig.isUnFold = false
    }
    /// call to change to unfold state
    public func mooUpdateToOpenState() {
        self.attributedText = self.mooConfig.unfoldAttributeString()
        self.mooConfig.isUnFold = true
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.delegate = self;
        /// some default set (you can modified as outside)
        self.textContainer.lineFragmentPadding = 0 /// clear side margin
        self.textContainerInset = .zero /// clear inset
        self.isEditable = false /// disable edit, otherwise click will pop up the keyboard
        self.isScrollEnabled = false /// disable scroll
    }

    private func moo_canUnfold() -> Bool {
        return self.mooConfig.unfoldLineCount > self.mooConfig.foldLineCount && !self.mooConfig.isUnFold
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MOOFoldTextView: UITextViewDelegate {
    
    /// handle click link action
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString == self.mooConfig.MOOUnfoldLinkScheme {
            /// click open button
            self.mooUpdateToOpenState()
            self.mooDelegate?.mooFoldViewShouldUpdateLayout(self)
            return false
        }
        if URL.absoluteString == self.mooConfig.MOOFoldLinkScheme {
            /// click close button
            self.mooUpdateToCloseState()
            self.mooDelegate?.mooFoldViewShouldUpdateLayout(self)
            return false
        }
        return true
    }
}
