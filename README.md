# MOAttributedTextView
<video id="video" controls="" preload="none" poster=" ">
      <source id="mp4" src="https://github.com/moxiaohui/MOAttributedTextView/blob/main/openAndClose.mp4" type="video/mp4">
</video>

# How to use

1. add the `MOAttributedTextView.swift` file to your project
2. then use as follows ：

```swift
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
```





