//
//  PostDetailsViewController.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import UIKit

class PostDetailsViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    //data from previous screen starts
    var feedDetails: FeedItem? = nil
    //data from previous screen ends
    
    private let postCommentCellIdentifier = String(describing: PostCommentTableViewCell.self)
    private let postDetailsCellIdentifier = String(describing: PostDetailsTableViewCell.self)
    
    //MARK: ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    //MARK: UI Related
    private func setUpView() {
        self.title = "Post Details"
        
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: postCommentCellIdentifier,
                               bundle: nil),
                         forCellReuseIdentifier: postCommentCellIdentifier)
        tableView.register(UINib(nibName: postDetailsCellIdentifier,
                               bundle: nil),
                         forCellReuseIdentifier: postDetailsCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - UITableViewDataSource
extension PostDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return feedDetails?.comments?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: postDetailsCellIdentifier,
                                                     for: indexPath) as! PostDetailsTableViewCell
            
            cell.setUpView(withFeed: feedDetails)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: postCommentCellIdentifier,
                                                     for: indexPath) as! PostCommentTableViewCell
            
            cell.setUpView(withPostComment: feedDetails?.comments?[indexPath.row])
            
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension PostDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
