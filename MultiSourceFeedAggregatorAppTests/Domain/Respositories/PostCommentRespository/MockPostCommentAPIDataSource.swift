//
//  MockPostCommentAPIDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

final class MockPostCommentAPIDataSource: PostCommentAPIDataSource {
    var result: APIDataSourceResult<[PostCommentModel]>!
    
    func getComments(completion: @escaping (APIDataSourceResult<[PostCommentModel]>) -> Void) {
        completion(result)
    }
}
