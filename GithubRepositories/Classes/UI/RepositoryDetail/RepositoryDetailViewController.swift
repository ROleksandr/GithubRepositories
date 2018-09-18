//
//  RepositoryDetailViewController.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/17/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit
import SafariServices

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = url else {
            return
        }
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        setUpSafariVC(with: url)
    }
    func setUpSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        addChildViewController(safariVC)
        containerView.addSubview(safariVC.view)
        safariVC.view.frame = containerView.bounds
        safariVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        safariVC.didMove(toParentViewController: self)
        safariVC.delegate = self
    }
}

extension RepositoryDetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}
