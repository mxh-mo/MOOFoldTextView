//
//  MOOTest2ViewController.swift
//  MOOFoldTextView_Example
//
//  Created by mikimo on 2023/11/19.
//  Copyright © 2023 Mobi Technology  All rights reserved.
//

import UIKit
import MOOFoldTextView

class MOOTest2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Test2 - TableView"
        // 4.3 add to super view
        self.view.addSubview(self.tableView)
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // 4.4 set frame
        self.tableView.frame = CGRect(x: 0.0,
                                      y: 100.0,
                                      width: CGRectGetWidth(self.view.bounds),
                                      height: CGRectGetHeight(self.view.bounds) - 100.0);
    }
    // 4.1 init table view
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
}

// 6 reload data after fold state changed
extension MOOTest2ViewController: MOOTableViewCellDelegate {
    func mooCellShouldReloadData(_ cell: UITableViewCell) {
        self.tableView.reloadData()
    }
}

// 5.1
extension MOOTest2ViewController: UITableViewDataSource {
    
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
}

// 5.2
extension MOOTest2ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let config = self.dataSource[indexPath.row]
        return config.currentHeight()
    }
}
