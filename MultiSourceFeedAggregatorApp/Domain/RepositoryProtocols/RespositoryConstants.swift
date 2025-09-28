//
//  RespositoryConstants.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

typealias RepositoryResult<T> = Result<RepositorySuccess<T>, RepositoryError>
typealias RepositorySuccess<T> = (data: T, isFromCache: Bool)

enum RepositoryError: Error {
    case apiDataSourceError(APIDataSourceError)
}
