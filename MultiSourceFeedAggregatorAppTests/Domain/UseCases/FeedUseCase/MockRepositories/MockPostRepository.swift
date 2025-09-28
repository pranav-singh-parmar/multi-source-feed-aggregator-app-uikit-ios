//
//  MockPostRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class MockPostRepository: PostRepository {
    var result: RepositoryResult<[PostModel]>!
    
    func getPosts(completion: @escaping (RepositoryResult<[PostModel]>) -> Void) {
        completion(result)
    }
}
