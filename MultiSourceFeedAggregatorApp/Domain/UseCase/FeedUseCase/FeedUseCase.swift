//
//  FeedUseCase.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol FeedUseCase {
    func fetchDetails(withLimit limit: Int,
                      completion: @escaping (Result<Feed, FeedUseCaseError>) -> Void)
    func paginate(from start: Int, withLimit limit: Int) -> [FeedItem]
}

enum FeedUseCaseError: Error, LocalizedError {
    case internetNotConnected
    case somethingWentWrong(errorMessage: String?)
    
    var errorDescription: String? {
        switch self {
        case .internetNotConnected:
            return NSLocalizedString("Internet Not Connected",
                                     comment: "Internet Not Connected")
        case .somethingWentWrong(let errorMessage):
            return NSLocalizedString(errorMessage ?? "Something Went Wrong",
                                     comment: errorMessage ?? "Something Went Wrong")
        }
    }
}
