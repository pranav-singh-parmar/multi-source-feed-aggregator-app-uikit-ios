//
//  PostCacheDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol PostCacheDataSource {
    func savePosts(_ posts: [PostModel], completion: ((Bool) -> Void)?)
    func getPosts(completion: @escaping ([PostModel]?) -> Void)
    func clear(completion: (() -> Void)?)
}
