//
//  MockPostImageAPIDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

final class MockPostImageAPIDataSource: PostImageAPIDataSource {
    var result: APIDataSourceResult<[PostImageModel]>!
    
    func getImages(completion: @escaping (APIDataSourceResult<[PostImageModel]>) -> Void) {
        completion(result)
    }
}
