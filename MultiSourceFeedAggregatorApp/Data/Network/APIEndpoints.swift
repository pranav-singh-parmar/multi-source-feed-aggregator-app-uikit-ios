//
//  APIEndpointsProtocol.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

//MARK: - APIEndpointsProtocol
protocol APIEndpointsProtocol {
    var endpoint: String { get }
    
    var getURLString: String { get }
}

//MARK: - BreakingBadEndpoints
enum AppEndpoints: APIEndpointsProtocol {
    case posts,
         users,
         comments,
         photos
    
    var endpoint: String {
        switch self {
        case .posts:
            return "posts"
        case .users:
            return "users"
        case .comments:
            return "comments"
        case .photos:
            return "photos"
        }
    }
    
    var getURLString: String {
        return "https://jsonplaceholder.typicode.com/" + self.endpoint
    }
}
