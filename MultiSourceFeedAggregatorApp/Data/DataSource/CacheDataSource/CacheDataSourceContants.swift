//
//  CacheDataSourceContants.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

typealias CacheDataSourceResult<T> = Result<T, CacheDataSourceError>

enum CacheDataSourceError: Error {
    case noDataAvailable
}
