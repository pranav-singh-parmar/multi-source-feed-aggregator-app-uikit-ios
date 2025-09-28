//
//  PostImageCacheDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol PostImageCacheDataSource {
    func savePostImages(_ postImages: [PostImageModel], completion: ((Bool) -> Void)?)
    func getPostImages(completion: @escaping ([PostImageModel]?) -> Void)
    func clear(completion: (() -> Void)?)
}
