//
//  PostCommentCacheDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol PostCommentCacheDataSource {
    func savePostComments(_ postComments: [PostCommentModel], completion: ((Bool) -> Void)?)
    func getPostComments(completion: @escaping ([PostCommentModel]?) -> Void)
    func clear(completion: (() -> Void)?)
}
