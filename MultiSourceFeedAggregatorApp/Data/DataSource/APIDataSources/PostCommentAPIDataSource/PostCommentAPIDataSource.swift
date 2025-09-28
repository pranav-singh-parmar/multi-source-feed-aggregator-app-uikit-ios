//
//  PostCommentAPIDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

protocol PostCommentAPIDataSource {
    func getComments(completion: @escaping (DataSourceResult<[PostCommentModel]>) -> Void)
}
