//
//  UserRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol UserRepository {
    func getUsers(completion: @escaping (RepositoryResult<[UserModel]>) -> Void)
}
