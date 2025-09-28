//
//  MockUserAPIDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

final class MockUserAPIDataSource: UserAPIDataSource {
    var result: APIDataSourceResult<[UserModel]>!
    
    func getUsers(completion: @escaping (APIDataSourceResult<[UserModel]>) -> Void) {
        completion(result)
    }
}
