//
//  PostCommentRepositoryIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostCommentRepositoryIMPL: PostCommentRepository {
    
    private let apiDS: any PostCommentAPIDataSource
    
    init(apiDS: any PostCommentAPIDataSource = PostCommentAPIDataSourceIMPL()) {
        self.apiDS = apiDS
    }
    
    func getComments(completion: @escaping (RepositoryResult<[PostCommentModel]>) -> Void) {
        apiDS.getComments { [weak self] result in
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
