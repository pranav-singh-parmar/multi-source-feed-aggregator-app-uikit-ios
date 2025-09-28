//
//  PostImageRepositoryIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostImageRepositoryIMPL: PostImageRepository {
    
    private let apiDS: any PostImageAPIDataSource
    
    init(apiDS: any PostImageAPIDataSource = PostImageAPIDataSourceIMPL()) {
        self.apiDS = apiDS
    }
    
    func getImages(completion: @escaping (RepositoryResult<[PostImageModel]>) -> Void) {
        apiDS.getImages() { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(.dataSourceError(error)))
            }
        }
    }
}
