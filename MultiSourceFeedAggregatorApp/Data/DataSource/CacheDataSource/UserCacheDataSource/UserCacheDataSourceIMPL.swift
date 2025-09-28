//
//  UserCacheDataSourceIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

class UserCacheDataSourceIMPL: UserCacheDataSource {
    
    private let queue = DispatchQueue(label: "cache_user_queue", qos: .background)
    
    func saveUsers(_ users: [UserModel], completion: ((Bool) -> Void)?) {
        queue.async {
            UserDefaults.cachedUsers = users
            DispatchQueue.main.async {
                completion?(true)
            }
        }
    }
    
    func getUsers(completion: @escaping ([UserModel]?) -> Void) {
        queue.async {
            let users = UserDefaults.cachedUsers
            DispatchQueue.main.async {
                completion(users)
            }
        }
    }
    
    func clear(completion: (() -> Void)? = nil) {
        queue.async {
            UserDefaults.cachedUsers = nil
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
