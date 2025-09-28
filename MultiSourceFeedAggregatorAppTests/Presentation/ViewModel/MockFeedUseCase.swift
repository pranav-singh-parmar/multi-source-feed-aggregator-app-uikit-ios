//
//  MockFeedUseCase.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class MockFeedUseCase: FeedUseCase {
    var fetchDetailsResult: UseCaseResult<Feed>?
    var paginateResult: [FeedItem] = []
    
    func fetchDetails(withLimit limit: Int,
                      completion: @escaping (UseCaseResult<Feed>) -> Void) {
        if let result = fetchDetailsResult {
            completion(result)
        }
    }
    
    func paginate(from start: Int, withLimit limit: Int) -> [FeedItem] {
        return paginateResult
    }
}
