//
//  MockPostCacheDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 29/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

final class MockPostCacheDataSource: PostCacheDataSource {
    
    var cachedPosts: [PostModel]?
    var saveCalled = false
    var clearCalled = false

    func savePosts(_ posts: [PostModel], completion: ((Bool) -> Void)?) {
        cachedPosts = posts
        saveCalled = true
        completion?(true)
    }
    
    func getPosts(completion: @escaping ([PostModel]?) -> Void) {
        completion(cachedPosts)
    }
    
    func clear(completion: (() -> Void)?) {
        cachedPosts = nil
        clearCalled = true
        completion?()
    }
}
