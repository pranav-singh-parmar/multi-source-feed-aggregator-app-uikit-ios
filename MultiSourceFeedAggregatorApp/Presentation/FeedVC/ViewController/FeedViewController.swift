//
//  FeedViewController.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import UIKit

class FeedViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var feedsTV: UITableView!
    
    //MARK: - Properties
    private let postCellIdentifier = String(describing: PostTableViewCell.self)
    private let viewModel = FeedViewModel()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: - View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        viewModel.fetchFeedList()
    }
    
    //MARK: - UI Related
    private func setUpView() {
        self.title = "Feed"
        
        feedsTV.register(PostTableViewCell.self, forCellReuseIdentifier: postCellIdentifier)
        feedsTV.delegate = self
        feedsTV.dataSource = self
        feedsTV.refreshControl = refreshControl
        
        viewModel.delegate = self
    }
    
    //MARK: - objc methods
    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.fetchFeedList()
    }
}

//MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedsTV.dequeueReusableCell(withIdentifier: postCellIdentifier,
                                               for: indexPath) as! PostTableViewCell
        
        
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        if viewModel.isLastIndex(indexPath) {
        //            if viewModel.fetchedAllData {
        //                feedsTV.clearFooter()
        //            } else {
        //                feedsTV.setActivityIndicatorAtFooter()
        //                viewModel.paginateWithIndex(indexPath)
        //            }
        //        }
    }
}

//MARK: - ABC
extension FeedViewController: ABC {
    func fetchingDetails() {
        
    }
    
    func reloadFeeds() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        feedsTV.reloadData()
    }
    
    func insertedFeedsAt(indexPath: IndexPath) {
        feedsTV.insertRows(at: [indexPath], with: .automatic)
    }
}
