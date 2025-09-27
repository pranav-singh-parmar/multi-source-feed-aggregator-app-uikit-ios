//
//  RepositoryError.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

typealias RepositoryResult<T> = Result<T, RepositoryError>

enum RepositoryError: Error {
    case dataSourceError(DataSourceError)
}
