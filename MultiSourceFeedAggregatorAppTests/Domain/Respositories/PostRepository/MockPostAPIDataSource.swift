//
//  MockPostAPIDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

final class MockPostAPIDataSource: PostAPIDataSource {
    var result: DataSourceResult<[PostModel]>!
    
    func getPosts(completion: @escaping (DataSourceResult<[PostModel]>) -> Void) {
        completion(result)
    }
}
