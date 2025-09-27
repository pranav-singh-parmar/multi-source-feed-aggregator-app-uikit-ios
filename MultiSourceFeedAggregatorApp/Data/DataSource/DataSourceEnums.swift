//
//  DataSourceEnums.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

typealias DataSourceResult<T> = Result<T, DataSourceError>

enum DataSourceError: Error {
    case urlRequestError(URLRequestError),
         apiRequestError(APIRequestError, String?), // //error and error message
         decodingError
}
