//
//  FeedViewDelegate.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol FeedViewDelegate: AnyObject {
    func didStartFetchingDetails()
    func didReloadFeeds(fromCache: Bool, withError error: UseCaseError?)
    func didInsertFeeds(at indexPaths: [IndexPath])
    func didToggleCommentsVisibility(to visible: Bool)
}
