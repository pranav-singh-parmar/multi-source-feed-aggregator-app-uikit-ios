//
//  FeedUseCase.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol FeedUseCase {
    func fetchDetails(withLimit limit: Int,
                      completion: @escaping (UseCaseResult<Feed>) -> Void)
    func paginate(from start: Int, withLimit limit: Int) -> [FeedItem]
}
