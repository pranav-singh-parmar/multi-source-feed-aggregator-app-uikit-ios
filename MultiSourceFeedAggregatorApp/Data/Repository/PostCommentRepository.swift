//
//  PostCommentRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostCommentRepository {
    
    private let dataSource: any PostCommentDataSourceProtocol
    
    init(dataSource: any PostCommentDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getComments(completion: @escaping (RepositoryResult<[PostCommentModel]>) -> Void) {
        dataSource.getComments { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success(let comments):
                completion(.success(comments))
            case .failure(let error):
                completion(.failure(.dataSourceError(error)))
            }
        }
    }
}
