//
//  MockUserRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class MockUserRepository: UserRepository {
    var result: RepositoryResult<[UserModel]>!
    
    func getUsers(completion: @escaping (RepositoryResult<[UserModel]>) -> Void) {
        completion(result)
    }
}
