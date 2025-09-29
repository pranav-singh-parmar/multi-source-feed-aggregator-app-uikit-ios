//
//  PostCommentCacheDataSourceIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

class PostCommentCacheDataSourceIMPL: PostCommentCacheDataSource {
    
    private let queue = DispatchQueue(label: "cache_post_comments_queue", qos: .background)
    
    func savePostComments(_ postComments: [PostCommentModel], completion: ((Bool) -> Void)?) {
        queue.async {
            UserDefaults.cachedPostComments = postComments
            completion?(true)
        }
    }
    
    func getPostComments(completion: @escaping ([PostCommentModel]?) -> Void) {
        queue.async {
            let postComments = UserDefaults.cachedPostComments
            completion(postComments)
        }
    }
    
    func clear(completion: (() -> Void)? = nil) {
        queue.async {
            UserDefaults.cachedPostComments = nil
            completion?()
        }
    }
}
