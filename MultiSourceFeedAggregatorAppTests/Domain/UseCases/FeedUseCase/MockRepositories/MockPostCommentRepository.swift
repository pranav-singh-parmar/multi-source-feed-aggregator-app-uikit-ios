//
//  MockPostCommentRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class MockPostCommentRepository: PostCommentRepository {
    var result: RepositoryResult<[PostCommentModel]>!
    
    func getComments(completion: @escaping (RepositoryResult<[PostCommentModel]>) -> Void) {
        completion(result)
    }
}
