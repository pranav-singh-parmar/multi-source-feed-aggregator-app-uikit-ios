//
//  MockFeedViewDelegate.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class MockFeedViewDelegate: FeedViewDelegate {
    var didStartFetchingCalled = false
    var didReloadFeedsCalled = false
    var didInsertFeedsCalledAt: [IndexPath] = []
    var didToggleCommentsVisibilityTo: Bool?
    
    func didStartFetchingDetails() {
        didStartFetchingCalled = true
    }
    
    func didReloadFeeds(withError error: FeedUseCaseError?) {
        didReloadFeedsCalled = true
    }
    
    func insertedFeedsAt(indexPath: IndexPath) {
        didInsertFeedsCalledAt.append(indexPath)
    }
    
    func didInsertFeeds(at indexPaths: [IndexPath]) {
        didInsertFeedsCalledAt.append(contentsOf: indexPaths)
    }
    
    func didToggleCommentsVisibility(to isVisible: Bool) {
        didToggleCommentsVisibilityTo = isVisible
    }
}
