//
//  RepositoryTableViewCell.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/17/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

protocol RepositoryTableViewCellDelegate: class {
    func showDetail(on cell: RepositoryTableViewCell)
}

class RepositoryTableViewCell: UITableViewCell {
    weak var delegate: RepositoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDetail))
        textLabel?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setUpWithModel(_ model: RepositoryViewModel) {
        textLabel?.text = model.name
        detailTextLabel?.text = "Stars: \(model.starsCount)"
    }
    
    // MARK: - Actions
    @objc private func showDetail() {
        delegate?.showDetail(on: self)
    }
}
