//
//  PostCommentTableViewCell.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import UIKit

class PostCommentTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    //MARK: TableViewCell Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        authorNameLabel.font = .systemFont(ofSize: 14, weight: .regular)
        authorEmailLabel.font = .systemFont(ofSize: 14, weight: .regular)
        commentLabel.font = .systemFont(ofSize: 16, weight: .regular)
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = .justified
        authorEmailLabel.textColor = .gray
    }
    
    //MARK: UI Related
    func setUpView(withPostComment postCommentModel: PostCommentModel?) {
        authorNameLabel.text = postCommentModel?.name ?? ""
        authorEmailLabel.text = postCommentModel?.email ?? ""
        commentLabel.text = postCommentModel?.body ?? ""
    }
}
