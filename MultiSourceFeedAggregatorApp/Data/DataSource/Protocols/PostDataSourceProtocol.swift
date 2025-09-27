//
//  PostDataSourceProtocol.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

protocol PostDataSourceProtocol {
    func getPosts(completion: @escaping (DataSourceResult<[PostModel]>) -> Void)
}
