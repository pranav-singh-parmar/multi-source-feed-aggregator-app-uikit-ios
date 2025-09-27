//
//  PostRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostRepository {
    
    private let dataSource: any PostDataSourceProtocol
    
    init(dataSource: any PostDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getPosts(completion: @escaping (RepositoryResult<[PostModel]>) -> Void) {
        dataSource.getPosts() { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(.dataSourceError(error)))
            }
        }
    }
}
