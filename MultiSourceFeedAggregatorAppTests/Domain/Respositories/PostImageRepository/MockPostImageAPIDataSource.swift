//
//  MockPostImageAPIDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

final class MockPostImageAPIDataSource: PostImageAPIDataSource {
    var result: DataSourceResult<[PostImageModel]>!
    
    func getImages(completion: @escaping (DataSourceResult<[PostImageModel]>) -> Void) {
        completion(result)
    }
}
