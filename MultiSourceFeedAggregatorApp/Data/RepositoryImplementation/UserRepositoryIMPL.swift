//
//  UserRepositoryIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class UserRepositoryIMPL: UserRepository {
    
    private let apiDS: any UserAPIDataSource
    
    init(apiDS: any UserAPIDataSource = UserAPIDataSourceIMPL()) {
        self.apiDS = apiDS
    }
    
    func getUsers(completion: @escaping (RepositoryResult<[UserModel]>) -> Void) {
        apiDS.getUsers() { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(.dataSourceError(error)))
            }
        }
    }
}
