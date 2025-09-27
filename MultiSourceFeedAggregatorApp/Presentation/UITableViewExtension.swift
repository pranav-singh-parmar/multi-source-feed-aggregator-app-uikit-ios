//
//  UITableViewExtension.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import UIKit

extension UITableView {
    func clearFooter() {
        self.tableFooterView = UIView()
    }
    
    func setActivityIndicatorAtFooter() {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))
        self.tableFooterView = spinner
    }
}
