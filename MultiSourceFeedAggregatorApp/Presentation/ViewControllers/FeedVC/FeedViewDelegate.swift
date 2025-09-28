//
//  FeedViewDelegate.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol FeedViewDelegate: AnyObject {
    func didStartFetchingDetails()
    func didReloadFeeds(withError error: FeedUseCaseError?)
    func didInsertFeeds(at indexPaths: [IndexPath])
    func didToggleCommentsVisibility(to visible: Bool)
}
