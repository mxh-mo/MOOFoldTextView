# MOOFoldTextView

[![CI Status](https://img.shields.io/travis/994355869@qq.com/MOOFoldTextView.svg?style=flat)](https://travis-ci.org/994355869@qq.com/MOOFoldTextView)
[![Version](https://img.shields.io/cocoapods/v/MOOFoldTextView.svg?style=flat)](https://cocoapods.org/pods/MOOFoldTextView)
[![License](https://img.shields.io/cocoapods/l/MOOFoldTextView.svg?style=flat)](https://cocoapods.org/pods/MOOFoldTextView)
[![Platform](https://img.shields.io/cocoapods/p/MOOFoldTextView.svg?style=flat)](https://cocoapods.org/pods/MOOFoldTextView)

## 1. Effect display

Test1：Direct Use：

<img src="./Test1-OpenAndClose.gif" style="zoom:80%;" />

----

Test2：Use in cell：

<img src="./Test2-OpenAndClose-Cell.gif" style="zoom:80%;" />

## 2. Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 3. Installation

MOOFoldTextView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MOOFoldTextView'
```
then import
```swift
import MOOFoldTextView
```

## 4. Usage

### 4.1 Direct Use

```swift
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


// 2.1 add to super view
self.view.addSubview(self.mooFoldTextView)
// 2.2 set config and reload
self.mooFoldTextView.mooConfig = self.mooFoldTextConfig
self.mooFoldTextView.mooReloadText()

// 3 set frame
self.mooFoldTextView.frame = CGRect(x: 0.0,
                                    y: 100.0,
                                    width: CGRectGetWidth(self.view.bounds),
                                    height: self.mooFoldTextConfig.currentHeight())
       
// 4 Implement Proxy
extension MOOTest1ViewController: MOOFoldTextViewDelegate {
    func mooFoldViewShouldUpdateLayout(_ foldTextView: MOOFoldTextView) {
        // update layout after fold state changed
        self.view.setNeedsLayout()
    }
}         
```

----

### 4.2 Use in cell

#### 4.2.1 at Custom TableViewCell

```swift
// 1.1 init
private lazy var attributeTextView: MOOFoldTextView = {
    let view = MOOFoldTextView(frame: .zero)
    view.backgroundColor = .cyan
    view.mooDelegate = self
    return view
}()
// 1.2 add to super view
self.contentView.addSubview(self.attributeTextView)
// 1.3 set frame
self.attributeTextView.frame = self.contentView.bounds


// 2 receive config and set to textView
var mooConfig: MOOFoldTextConfig = MOOFoldTextConfig() {
    didSet {
        self.attributeTextView.mooConfig = self.mooConfig
        self.attributeTextView.mooReloadText()
    }
}

// 3.1 define protocol to forward event
public protocol MOOTableViewCellDelegate: AnyObject {
    func mooCellShouldReloadData(_ cell: UITableViewCell)
}
// 3.2
weak var mooDelegate: MOOTableViewCellDelegate?
// 3.3
extension MOOTableViewCell: MOOFoldTextViewDelegate {
    func mooFoldViewShouldUpdateLayout(_ foldTextView: MOOFoldTextView) {
        self.mooDelegate?.mooCellShouldReloadData(self)
    }
}
```

#### 4.2.2 at View Controller 

```swift
import MOOFoldTextView

// 4.1 init tableView
private lazy var tableView: UITableView = {
    let view = UITableView(frame: .zero, style: .grouped)
    view.register(MOOTableViewCell.self, forCellReuseIdentifier: "MOOTableViewCell")
    view.dataSource = self
    view.delegate = self
    return view
}()
// 4.2 init dataSource with config
private lazy var dataSource: [MOOFoldTextConfig] = {
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
    return [config]
}()
// 4.3 add to super view
self.view.addSubview(self.tableView)
self.tableView.reloadData()
// 4.4 set frame
self.tableView.frame = CGRect(x: 0.0,
                              y: 100.0,
                              width: CGRectGetWidth(self.view.bounds),
                              height: CGRectGetHeight(self.view.bounds) - 100.0);
                              
// 5.1 Implementation UITableViewDataSource
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.dataSource.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MOOTableViewCell",
                                             for: indexPath)
    if let cell = cell as? MOOTableViewCell {
        cell.mooConfig = self.dataSource[indexPath.row]
        cell.mooDelegate = self
    }
    return cell
}
// 5.2 Implementation UITableViewDelegate
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let config = self.dataSource[indexPath.row]
    return config.currentHeight()
}

// 6 reload data after fold state changed
extension MOOTest2ViewController: MOOTableViewCellDelegate {
    func mooCellShouldReloadData(_ cell: UITableViewCell) {
        self.tableView.reloadData()
    }
}

```

## 5. Author

[moxiaoyan](https://github.com/mxh-mo)

## 6. License

MOOFoldTextView is available under the MIT license. See the LICENSE file for more info.
