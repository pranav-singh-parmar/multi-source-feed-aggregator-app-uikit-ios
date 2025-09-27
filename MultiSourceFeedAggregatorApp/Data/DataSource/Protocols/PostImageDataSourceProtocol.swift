//
//  PostImageDataSourceProtocol.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

protocol PostImageDataSourceProtocol {
    func getImages(completion: @escaping (DataSourceResult<[PostImageModel]>) -> Void)
}
