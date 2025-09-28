//
//  MockPostCommentCacheDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 29/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

final class MockPostCommentCacheDataSource: PostCommentCacheDataSource {
    var cachedPostComments: [PostCommentModel]?
    var saveCalled = false
    var clearCalled = false

    func savePostComments(_ postComments: [PostCommentModel], completion: ((Bool) -> Void)?) {
        cachedPostComments = postComments
        saveCalled = true
        completion?(true)
    }
    
    func getPostComments(completion: @escaping ([PostCommentModel]?) -> Void) {
        completion(cachedPostComments)
    }
    
    func clear(completion: (() -> Void)?) {
        cachedPostComments = nil
        clearCalled = true
        completion?()
    }
}
