//
//  MockPostImageRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class MockPostImageRepository: PostImageRepository {
    var result: RepositoryResult<[PostImageModel]>!
    
    func getImages(completion: @escaping (RepositoryResult<[PostImageModel]>) -> Void) {
        completion(result)
    }
}
