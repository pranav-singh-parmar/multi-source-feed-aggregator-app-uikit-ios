//
//  Enums.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

enum HTTPMethod: String {
    case get, post, put, delete
}

enum MimeTypeEnum: String {
    case json = "application/json",
         text = "text/plain",
         html = "text/html"
}

enum APIRequestResult<Success, Failure> where Failure : Error {
    case success(statusCode: Int, Success)
    case failure(Failure, Data?)
}
