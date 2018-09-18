//
//  RepositoryListViewController.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/13/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

class RepositoryListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    private let repositoriesDataManager = RepositoriesDataManager()
    private var searchItem: DispatchWorkItem?
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.sizeToFit()
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        navigationController?.definesPresentationContext = false
        repositoriesDataManager.onDidLoadRepositories = { [weak tableView] in
            DispatchQueue.main.async {
                tableView?.reloadData()
            }
        }
        repositoriesDataManager.onDidUpdateLoading = { [weak activityIndicatorView] isLoading in
            DispatchQueue.main.async {
                isLoading ? activityIndicatorView?.startAnimating() : activityIndicatorView?.stopAnimating()
            }
        }
        repositoriesDataManager.onError = { [weak self] errorString in
            DispatchQueue.main.async {
                self?.showAlertController(text: errorString)
            }
        }
        repositoriesDataManager.onNoResults = { [weak noResultsLabel] in
            DispatchQueue.main.async {
                noResultsLabel?.isHidden = false
            }
        }
    }
    func showAlertController(text: String) {
        let alertController = UIAlertController(title: text,
                                                message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    func searchReps() {
        let query = searchController.searchBar.text ?? ""
        repositoriesDataManager.search(query)
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoriesDataManager.numberOfCells
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath)
        if let theCell = cell as? RepositoryTableViewCell {
            theCell.setUpWithModel(repositoriesDataManager.repositoryCellViewModel(at: indexPath))
            theCell.delegate = self
        }
        return cell
    }
}

extension RepositoryListViewController: RepositoryTableViewCellDelegate {
    func showDetail(on cell: RepositoryTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        if let indexPath = indexPath {
            let repository = repositoriesDataManager.repositoryCellViewModel(at: indexPath)
            repositoriesDataManager.saveRepository(at: indexPath)
            let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? RepositoryDetailViewController {
                detailVC.url = repository.url
                detailVC.modalPresentationStyle = .overFullScreen
                present(detailVC, animated: false, completion: nil)
            }
        }
    }
}

extension RepositoryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        noResultsLabel.isHidden = true
        searchItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.searchReps()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        searchItem = workItem
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        noResultsLabel.isHidden = true
        repositoriesDataManager.cancelSearch()
    }
}
