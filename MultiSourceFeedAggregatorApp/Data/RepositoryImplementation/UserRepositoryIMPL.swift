//
//  UserRepositoryIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class UserRepositoryIMPL: UserRepository {
    
    private let apiDS: any UserAPIDataSource
    private let cacheDS: any UserCacheDataSource
    
    init(apiDS: any UserAPIDataSource = UserAPIDataSourceIMPL(),
         cacheDS: any UserCacheDataSource = UserCacheDataSourceIMPL()) {
        self.apiDS = apiDS
        self.cacheDS = cacheDS
    }
    
    func getUsers(completion: @escaping (RepositoryResult<[UserModel]>) -> Void) {
        apiDS.getUsers() { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let users):
                cacheDS.saveUsers(users, completion: nil)
                completion(.success(RepositorySuccess(data: users, isFromCache: false)))
            case .failure(let error):
                switch error {
                case .apiRequestError(let apiRequestError, _):
                    switch apiRequestError {
                    case .internetNotConnected:
                        cacheDS.getUsers { [weak self] cachedUsers in
                            guard self != nil else { return }
                            
                            if let cachedUsers,
                               !cachedUsers.isEmpty {
                                completion(.success(RepositorySuccess(data: cachedUsers,
                                                                      isFromCache: true)))
                            } else {
                                completion(.failure(.apiDataSourceError(error)))
                            }
                        }
                    default:
                        completion(.failure(.apiDataSourceError(error)))
                    }
                default:
                    completion(.failure(.apiDataSourceError(error)))
                }
            }
        }
    }
}
