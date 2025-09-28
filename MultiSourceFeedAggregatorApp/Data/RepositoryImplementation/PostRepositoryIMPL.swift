//
//  PostRepositoryIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostRepositoryIMPL: PostRepository {
    
    private let apiDS: any PostAPIDataSource
    
    init(apiDS: any PostAPIDataSource = PostAPIDataSourceIMPL()) {
        self.apiDS = apiDS
    }
    
    func getPosts(completion: @escaping (RepositoryResult<[PostModel]>) -> Void) {
        apiDS.getPosts() { [weak self] result in
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
