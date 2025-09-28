//
//  MockPostImageCacheDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 29/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

final class MockPostImageCacheDataSource: PostImageCacheDataSource {
    var cachedPostImages: [PostImageModel]?
    var saveCalled = false
    var clearCalled = false

    func savePostImages(_ postImages: [PostImageModel], completion: ((Bool) -> Void)?) {
        cachedPostImages = postImages
        saveCalled = true
        completion?(true)
    }
    
    func getPostImages(completion: @escaping ([PostImageModel]?) -> Void) {
        completion(cachedPostImages)
    }
    
    func clear(completion: (() -> Void)?) {
        cachedPostImages = nil
        clearCalled = true
        completion?()
    }
}
