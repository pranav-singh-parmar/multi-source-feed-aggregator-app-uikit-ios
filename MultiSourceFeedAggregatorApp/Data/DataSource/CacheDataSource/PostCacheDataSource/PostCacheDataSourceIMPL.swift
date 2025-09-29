//
//  PostCacheDataSourceIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

class PostCacheDataSourceIMPL: PostCacheDataSource {
    private let defaults = UserDefaults.standard
    private let queue = DispatchQueue(label: "cache_post_queue", qos: .background)
    
    func savePosts(_ posts: [PostModel], completion: ((Bool) -> Void)? = nil) {
        queue.async {
            UserDefaults.cachedPosts = posts
            completion?(true)
        }
    }
    
    func getPosts(completion: @escaping ([PostModel]?) -> Void) {
        queue.async {
            let posts = UserDefaults.cachedPosts
            completion(posts)
        }
    }
    
    func clear(completion: (() -> Void)? = nil) {
        queue.async {
            UserDefaults.cachedPosts = nil
            completion?()
        }
    }
}
