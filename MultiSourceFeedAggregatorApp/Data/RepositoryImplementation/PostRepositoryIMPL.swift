//
//  PostRepositoryIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostRepositoryIMPL: PostRepository {
    
    private let apiDS: any PostAPIDataSource
    private let cacheDS: any PostCacheDataSource
    
    init(apiDS: any PostAPIDataSource = PostAPIDataSourceIMPL(),
         cacheDS: any PostCacheDataSource = PostCacheDataSourceIMPL()) {
        self.apiDS = apiDS
        self.cacheDS = cacheDS
    }
    
    func getPosts(completion: @escaping (RepositoryResult<[PostModel]>) -> Void) {
        apiDS.getPosts() { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let posts):
                cacheDS.savePosts(posts, completion: nil)
                completion(.success(RepositorySuccess(data: posts, isFromCache: false)))
            case .failure(let error):
                switch error {
                case .apiRequestError(let apiRequestError, _):
                    switch apiRequestError {
                    case .internetNotConnected:
                        cacheDS.getPosts { [weak self] cachedPosts in
                            guard self != nil else { return }
                            
                            if let cachedPosts,
                               !cachedPosts.isEmpty {
                                completion(.success(RepositorySuccess(data: cachedPosts,
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
