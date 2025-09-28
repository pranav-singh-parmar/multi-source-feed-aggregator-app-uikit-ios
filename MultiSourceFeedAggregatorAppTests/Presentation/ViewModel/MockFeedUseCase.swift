//
//  MockFeedUseCase.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class MockFeedUseCase: FeedUseCase {
    var fetchDetailsResult: Result<Feed, FeedUseCaseError>?
    var paginateResult: [FeedItem] = []
    
    func fetchDetails(withLimit limit: Int,
                      completion: @escaping (Result<Feed, FeedUseCaseError>) -> Void) {
        if let result = fetchDetailsResult {
            completion(result)
        }
    }
    
    func paginate(from start: Int, withLimit limit: Int) -> [FeedItem] {
        return paginateResult
    }
}
