//
//  PostImageCacheDataSourceIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

class PostImageCacheDataSourceIMPL: PostImageCacheDataSource {
    private let queue = DispatchQueue(label: "cache_post_images_queue", qos: .background)
    
    func savePostImages(_ postImages: [PostImageModel], completion: ((Bool) -> Void)?) {
        queue.async {
            UserDefaults.cachedPostImages = postImages
            completion?(true)
        }
    }
    
    func getPostImages(completion: @escaping ([PostImageModel]?) -> Void) {
        queue.async {
            let postImages = UserDefaults.cachedPostImages
            completion(postImages)
        }
    }
    
    func clear(completion: (() -> Void)? = nil) {
        queue.async {
            UserDefaults.cachedPostImages = nil
            completion?()
        }
    }
}
