//
//  PostImageRepositoryIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostImageRepositoryIMPL: PostImageRepository {
    
    private let apiDS: any PostImageAPIDataSource
    private let cacheDS: any PostImageCacheDataSource
    
    init(apiDS: any PostImageAPIDataSource = PostImageAPIDataSourceIMPL(),
         cacheDS: any PostImageCacheDataSource = PostImageCacheDataSourceIMPL()) {
        self.apiDS = apiDS
        self.cacheDS = cacheDS
    }
    
    func getImages(completion: @escaping (RepositoryResult<[PostImageModel]>) -> Void) {
        apiDS.getImages() { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let postImages):
                cacheDS.savePostImages(postImages, completion: nil)
                completion(.success(RepositorySuccess(data: postImages, isFromCache: false)))
            case .failure(let error):
                switch error {
                case .apiRequestError(let apiRequestError, _):
                    switch apiRequestError {
                    case .internetNotConnected:
                        cacheDS.getPostImages { [weak self] cachedPostImages in
                            guard self != nil else { return }
                            
                            if let cachedPostImages,
                               !cachedPostImages.isEmpty {
                                completion(.success(RepositorySuccess(data: cachedPostImages,
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
