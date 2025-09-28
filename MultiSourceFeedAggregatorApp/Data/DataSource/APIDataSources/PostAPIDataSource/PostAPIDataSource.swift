//
//  PostAPIDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

protocol PostAPIDataSource {
    func getPosts(completion: @escaping (APIDataSourceResult<[PostModel]>) -> Void)
}
