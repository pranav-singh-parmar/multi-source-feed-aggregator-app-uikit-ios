//
//  FeedModel.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

struct Feed {
    let totalPosts: Int?
    let items: [FeedItem]?
}

struct FeedItem {
    let post: PostModel?
    let user: UserModel?
    let comments: [PostCommentModel]?
    //let images: [PostImageModel]?
    let dummyImage: String?
}
