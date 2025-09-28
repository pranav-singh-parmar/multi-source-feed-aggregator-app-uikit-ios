//
//  PostImageRepository.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol PostImageRepository {
    func getImages(completion: @escaping (RepositoryResult<[PostImageModel]>) -> Void)
}
