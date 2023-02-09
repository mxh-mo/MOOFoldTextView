//
//  MOTest2ViewController.swift
//  MOAttributedTextView
//
//  Created by 莫晓卉 on 2020/12/6.
//

import UIKit

class MOTest2ViewController: UIViewController {
    // 5.2
    var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 400), style: .grouped)
        tableView.register(MOTableViewCell.self, forCellReuseIdentifier: "MOTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Test2-TableView"
        test2()
    }

    func test2() {
        // 4. calculation height
        MOAttributedTextView.calculateHeight(text: allText, closeText: "Close", font: .systemFont(ofSize: 16), lineSpacing: 10, width: 300, lessLine: 3) { (closeHeight, openHeight) in
            textViewCloseHeight = closeHeight
            textViewOpenHeight = openHeight
        }
        // 5.3
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.reloadData()
    }
    private var textViewCloseHeight: CGFloat = 0.0
    private var textViewOpenHeight: CGFloat = 0.0
    // 5.1 dataSource
    private var textIsOpen: Bool = false
    private let allText =
        """
        Swift is a type-safe language, which means the language helps you to be clear about\
         the types of values your code can work with. If part of your code requires a String,\
        type safety prevents you from passing it an Int by mistake. Likewise, type safety\
        prevents you from accidentally passing an optional String
        """
}

// 6. Achieve proxy refresh height
extension MOTest2ViewController: MOTableViewCellDelegate {
    /// receive textView tap action
    /// - Parameter isOpen: textView open or close
    func tapTextViewCell(_ isOpen: Bool) {
        textIsOpen = isOpen
        tableView.reloadData() // to reload cell height
    }
}

// 5.4
extension MOTest2ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MOTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MOTableViewCell", for: indexPath) as! MOTableViewCell
        cell.allText = allText
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return textIsOpen ? textViewOpenHeight : textViewCloseHeight
    }
}

