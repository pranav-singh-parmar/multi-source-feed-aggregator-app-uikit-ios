//
//  UseCaseConstants.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

typealias UseCaseResult<T> = Result<RepositorySuccess<T>, UseCaseError>
typealias UseCaseSuccess<T> = (data: T, isFromCache: Bool)

enum UseCaseError: Error, LocalizedError {
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
