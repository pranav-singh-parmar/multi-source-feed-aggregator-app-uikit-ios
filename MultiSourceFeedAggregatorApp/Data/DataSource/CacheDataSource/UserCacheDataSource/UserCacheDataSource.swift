//
//  UserCacheDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol UserCacheDataSource {
    func saveUsers(_ users: [UserModel], completion: ((Bool) -> Void)?)
    func getUsers(completion: @escaping ([UserModel]?) -> Void)
    func clear(completion: (() -> Void)?)
}
