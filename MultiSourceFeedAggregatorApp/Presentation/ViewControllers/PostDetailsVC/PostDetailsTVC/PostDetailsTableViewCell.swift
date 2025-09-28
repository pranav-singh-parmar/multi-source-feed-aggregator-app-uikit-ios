//
//  PostDetailsTableViewCell.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import UIKit

class PostDetailsTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorContactLabel: UILabel!
    @IBOutlet weak var authorCompanyLabel: UILabel!
    @IBOutlet weak var authorAddressLabel: UILabel!
    
    @IBOutlet weak var postIV: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    //MARK: TableViewCell Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    //MARK: UI Related
    private func setUpView() {
        authorNameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        authorContactLabel.font = .systemFont(ofSize: 15, weight: .medium)
        authorCompanyLabel.font = .systemFont(ofSize: 15, weight: .regular)
        authorAddressLabel.font = .systemFont(ofSize: 15, weight: .regular)
        postTitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        postBodyLabel.font = .systemFont(ofSize: 15, weight: .regular)
        commentsLabel.font = .systemFont(ofSize: 14, weight: .light)
        
        authorContactLabel.textColor = .gray
        commentsLabel.textColor = .gray
        
        authorContactLabel.numberOfLines = 2
        authorAddressLabel.numberOfLines = 0
        postTitleLabel.numberOfLines = 0
        postBodyLabel.numberOfLines = 0
    }
    
    func setUpView(withFeed feed: FeedItem?) {
        authorNameLabel.text = feed?.user?.name ?? ""
        authorContactLabel.text = "\(feed?.user?.email ?? "")\n\(feed?.user?.phone ?? "")"
        authorAddressLabel.text = "Address: \(feed?.user?.address?.completeAddress ?? "")"
        authorCompanyLabel.text = "Company: \(feed?.user?.company?.name ?? "")"
        
        postIV.loadImage(fromURLString: feed?.dummyImage ?? "")
        
        postTitleLabel.text = feed?.post?.title ?? ""
        postBodyLabel.text = feed?.post?.body ?? ""
        let comments = feed?.comments ?? []
        if comments.isEmpty {
            commentsLabel.text = "No comments added."
        } else {
            let commentsCount = comments.count
            if commentsCount == 1 {
                commentsLabel.text = "1 person has commented on this post."
            } else {
                commentsLabel.text = "\(commentsCount) people have have commented"
            }
        }
    }
}
