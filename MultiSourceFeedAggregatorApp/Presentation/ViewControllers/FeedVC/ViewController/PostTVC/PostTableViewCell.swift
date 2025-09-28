//
//  PostTableViewCell.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var postIV: UIImageView!
    
    //MARK: TableViewCell Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        authorNameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        postTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        commentsCountLabel.font = .systemFont(ofSize: 15, weight: .regular)
        commentsCountLabel.textColor = .gray
        postTitleLabel.numberOfLines = 0
    }
    
    //MARK: UI Related
    func setUpView(withFeedItem feedItem: FeedItem,
                   andCommentsVisibility commentsVisibility: Bool) {
        authorNameLabel.text = feedItem.user?.name ?? ""
        postTitleLabel.text = feedItem.post?.title ?? ""
        commentsCountLabel.isHidden = !commentsVisibility
        let comments = feedItem.comments ?? []
        if comments.isEmpty {
            commentsCountLabel.text = "No comments added."
        } else {
            let commentsCount = comments.count
            if commentsCount == 1 {
                commentsCountLabel.text = "1 person has commented on this post."
            } else {
                commentsCountLabel.text = "\(commentsCount) people have have commented"
            }
        }
        //postIV.image = ""
    }
    
    func updateCommentsVisibility(to visible: Bool) {
        commentsCountLabel.isHidden = !visible
    }
}
