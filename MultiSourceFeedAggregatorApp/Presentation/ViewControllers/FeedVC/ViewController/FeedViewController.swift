//
//  FeedViewController.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import UIKit

class FeedViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var feedsTV: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currentStateLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    //MARK: Properties
    private let postCellIdentifier = String(describing: PostTableViewCell.self)
    private let viewModel = FeedViewModel()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        viewModel.fetchFeedList()
    }
    
    //MARK: UI Related
    private func setUpView() {
        self.title = "Feed"
        
        let toggleSwitch = UISwitch()
        toggleSwitch.isOn = viewModel.showComments
        toggleSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
        let switchItem = UIBarButtonItem(customView: toggleSwitch)
        self.navigationItem.rightBarButtonItem = switchItem
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        
        retryButton.isHidden = true
        currentStateLabel.isHidden = true
        
        feedsTV.register(UINib(nibName: postCellIdentifier,
                               bundle: nil),
                         forCellReuseIdentifier: postCellIdentifier)
        feedsTV.delegate = self
        feedsTV.dataSource = self
        feedsTV.refreshControl = refreshControl
        
        viewModel.delegate = self
    }
    
    //MARK: objc methods
    @objc func onRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.fetchFeedList()
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
        viewModel.toggleCommentsVisibility()
        let message = viewModel.showComments ? "Comments Count Visible" : "Comments Count Hidden"
        self.showToast(withMessage: message)
    }
    
    //MARK: IBActions
    @IBAction func retryBTNACN(_ sender: UIButton) {
        viewModel.fetchFeedList()
    }
}

//MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedsTV.dequeueReusableCell(withIdentifier: postCellIdentifier,
                                               for: indexPath) as! PostTableViewCell
        
        cell.setUpView(withFeedItem: viewModel.feedItems[indexPath.row],
                       andCommentsVisibility: viewModel.showComments)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PostDetailsViewController()
        vc.feedDetails = viewModel.feedItems[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.isLastIndex(indexPath) {
            if viewModel.fetchedAllData {
                feedsTV.clearFooter()
            } else {
                feedsTV.setActivityIndicatorAtFooter()
                viewModel.paginateWithIndex(indexPath)
            }
        }
    }
}

//MARK: - FeedViewDelegate
extension FeedViewController: FeedViewDelegate {
    func didStartFetchingDetails() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if !refreshControl.isRefreshing {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                currentStateLabel.isHidden = false
                currentStateLabel.text = "Fetching Data..."
                retryButton.isHidden = true
            }
        }
    }
    
    func didReloadFeeds(fromCache: Bool, withError error: UseCaseError?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            } else {
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
            }
            if viewModel.currentLength == 0 {
                if let error {
                    currentStateLabel.text = error.localizedDescription
                } else {
                    currentStateLabel.text = "No Data Available"
                }
                currentStateLabel.isHidden = false
                retryButton.isHidden = false
                feedsTV.isHidden = true
            } else {
                if fromCache {
                    self.showToast(withMessage: "Offline Mode")
                } else if let error {
                    self.showToast(withMessage: error.localizedDescription)
                }
                currentStateLabel.isHidden = true
                retryButton.isHidden = true
                feedsTV.isHidden = false
                //feedsTV.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            feedsTV.reloadData()
        }
    }
    
    func didInsertFeeds(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            feedsTV.beginUpdates()
            feedsTV.insertRows(at: indexPaths, with: .automatic)
            feedsTV.endUpdates()
        }
    }
    
    func didToggleCommentsVisibility(to visible: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            feedsTV.beginUpdates()
            for cell in feedsTV.visibleCells {
                if let feedCell = cell as? PostTableViewCell {
                    feedCell.updateCommentsVisibility(to: visible)
                }
            }
            feedsTV.endUpdates()
        }
    }
}
