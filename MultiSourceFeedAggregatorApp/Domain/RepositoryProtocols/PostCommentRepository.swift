//
//  PostCommentRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol PostCommentRepository {
    func getComments(completion: @escaping (RepositoryResult<[PostCommentModel]>) -> Void)
}
