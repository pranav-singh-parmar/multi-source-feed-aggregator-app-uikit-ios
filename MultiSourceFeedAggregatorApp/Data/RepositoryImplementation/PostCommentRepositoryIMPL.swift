//
//  PostCommentRepositoryIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostCommentRepositoryIMPL: PostCommentRepository {
    
    private let apiDS: any PostCommentAPIDataSource
    private let cacheDS: any PostCommentCacheDataSource
    
    init(apiDS: any PostCommentAPIDataSource = PostCommentAPIDataSourceIMPL(),
         cacheDS: any PostCommentCacheDataSource = PostCommentCacheDataSourceIMPL()) {
        self.apiDS = apiDS
        self.cacheDS = cacheDS
    }
    
    func getComments(completion: @escaping (RepositoryResult<[PostCommentModel]>) -> Void) {
        apiDS.getComments { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let postComments):
                cacheDS.savePostComments(postComments, completion: nil)
                completion(.success(RepositorySuccess(data: postComments, isFromCache: false)))
            case .failure(let error):
                switch error {
                case .apiRequestError(let apiRequestError, _):
                    switch apiRequestError {
                    case .internetNotConnected:
                        cacheDS.getPostComments { [weak self] cachedPostComments in
                            guard self != nil else { return }
                            
                            if let cachedPostComments,
                               !cachedPostComments.isEmpty {
                                completion(.success(RepositorySuccess(data: cachedPostComments,
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
