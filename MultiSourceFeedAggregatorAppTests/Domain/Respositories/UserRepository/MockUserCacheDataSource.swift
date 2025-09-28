//
//  MockUserCacheDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 29/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

final class MockUserCacheDataSource: UserCacheDataSource {
    var cachedUsers: [UserModel]?
    var saveCalled = false
    var clearCalled = false

    func saveUsers(_ users: [UserModel], completion: ((Bool) -> Void)?) {
        cachedUsers = users
        saveCalled = true
        completion?(true)
    }
    
    func getUsers(completion: @escaping ([UserModel]?) -> Void) {
        completion(cachedUsers)
    }
    
    func clear(completion: (() -> Void)?) {
        cachedUsers = nil
        clearCalled = true
        completion?()
    }
}
