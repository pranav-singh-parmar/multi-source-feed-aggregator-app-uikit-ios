//
//  PostRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol PostRepository {
    func getPosts(completion: @escaping (RepositoryResult<[PostModel]>) -> Void)
}
