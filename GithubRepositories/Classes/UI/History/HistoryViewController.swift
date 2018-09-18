//
//  HistoryViewController.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/17/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let historyDataManager = HistoryDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        historyDataManager.onDidLoadRepositories = { [weak tableView] in
            tableView?.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyDataManager.loadRecentRepositories()
    }
    @IBAction func clear(_ sender: Any) {
        historyDataManager.removeAll()
    }
}

extension HistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyDataManager.numberOfCells
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentRepositoriesCell", for: indexPath)
        if let theCell = cell as? RepositoryTableViewCell {
            theCell.setUpWithModel(historyDataManager.repositoryCellViewModel(at: indexPath))
        }
        return cell
    }
}
