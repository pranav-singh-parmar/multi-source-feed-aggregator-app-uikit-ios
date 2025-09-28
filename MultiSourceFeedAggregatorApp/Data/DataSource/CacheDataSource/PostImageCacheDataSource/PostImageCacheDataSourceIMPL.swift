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
            DispatchQueue.main.async {
                completion?(true)
            }
        }
    }
    
    func getPostImages(completion: @escaping ([PostImageModel]?) -> Void) {
        queue.async {
            let postImages = UserDefaults.cachedPostImages
            DispatchQueue.main.async {
                completion(postImages)
            }
        }
    }
    
    func clear(completion: (() -> Void)? = nil) {
        queue.async {
            UserDefaults.cachedPostImages = nil
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
