//
//  APIRequestStatus.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

enum APIRequestStatus {
    case notConsumedOnce, isBeingConsumed, consumedWithSuccess, consumedWithError
    
    var isAPIConsumed: Bool {
        return self == .consumedWithSuccess || self == .consumedWithError
    }
}
