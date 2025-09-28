//
//  APIDataSourceConstants.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

typealias APIDataSourceResult<T> = Result<T, APIDataSourceError>

enum APIDataSourceError: Error {
    case urlRequestError(URLRequestError),
         apiRequestError(APIRequestError, String?), //error and error message
         decodingError
}
