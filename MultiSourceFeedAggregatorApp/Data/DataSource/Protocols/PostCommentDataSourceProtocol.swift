//
//  PostCommentDataSourceProtocol.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

protocol PostCommentDataSourceProtocol {
    func getComments(completion: @escaping (DataSourceResult<[PostCommentModel]>) -> Void)
}
