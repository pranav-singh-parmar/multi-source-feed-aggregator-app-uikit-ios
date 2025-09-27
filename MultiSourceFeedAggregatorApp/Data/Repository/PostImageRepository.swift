//
//  PostImageRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostImageRepository {
    
    private let dataSource: any PostImageDataSourceProtocol
    
    init(dataSource: any PostImageDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getImages(completion: @escaping (RepositoryResult<[PostImageModel]>) -> Void) {
        dataSource.getImages() { [weak self] result in
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
