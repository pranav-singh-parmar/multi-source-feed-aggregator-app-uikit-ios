//
//  FeedViewModelTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class FeedViewModelTests: XCTestCase {
    
    func testFetchFeedListSuccess() {
        let post = PostModel.getTestModelOne
        let user = UserModel.getTestModelOne
        let feedItems = [FeedItem(post: post,
                                  user: user,
                                  comments: [],
                                  dummyImage: "" )]
        let feed = Feed(totalPosts: 1, items: feedItems)
        
        let mockUseCase = MockFeedUseCase()
        mockUseCase.fetchDetailsResult = .success(feed)
        
        let mockDelegate = MockFeedViewDelegate()
        
        let viewModel = FeedViewModel(feedUC: mockUseCase)
        viewModel.delegate = mockDelegate
        
        viewModel.fetchFeedList()
        
        XCTAssertEqual(viewModel.feedItems.count, 1)
        XCTAssertEqual(viewModel.currentLength, 1)
        XCTAssertEqual(viewModel.getPostsAS, .consumedWithSuccess)
        XCTAssertTrue(mockDelegate.didStartFetchingCalled)
        XCTAssertTrue(mockDelegate.didReloadFeedsCalled)
    }
    
    func testFetchFeedListFailure() {
        let mockUseCase = MockFeedUseCase()
        mockUseCase.fetchDetailsResult = .failure(.internetNotConnected)
        
        let mockDelegate = MockFeedViewDelegate()
        let viewModel = FeedViewModel(feedUC: mockUseCase)
        viewModel.delegate = mockDelegate
        
        viewModel.fetchFeedList()
        
        XCTAssertEqual(viewModel.getPostsAS, .consumedWithError)
        XCTAssertTrue(mockDelegate.didStartFetchingCalled)
        XCTAssertTrue(mockDelegate.didReloadFeedsCalled)
    }
    
    func testPaginateWithIndexAppendsFeedItems() {
        let newPost = PostModel.getTestModelTwo
        let newUser = UserModel.getTestModelTwo
        let newFeedItems = [FeedItem(post: newPost,
                                  user: newUser,
                                  comments: [],
                                  dummyImage: "" )]
        let mockUseCase = MockFeedUseCase()
        mockUseCase.paginateResult = newFeedItems
        
        let mockDelegate = MockFeedViewDelegate()
        let viewModel = FeedViewModel(feedUC: mockUseCase)
        viewModel.delegate = mockDelegate
        
        /// Pre-populate some feed items
        let post = PostModel.getTestModelOne
        let user = UserModel.getTestModelOne
        let existingFeedItem = FeedItem(post: post, user: user, comments: [], dummyImage: "")
        viewModel.setFeedItemsForTesting([existingFeedItem], currentLength: 1, total: 3)
        
        viewModel.paginateWithIndex(IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(viewModel.feedItems.count, 2)
        XCTAssertEqual(viewModel.getPostsAS, .consumedWithSuccess)
        XCTAssertEqual(mockDelegate.didInsertFeedsCalledAt.count, 1)
    }
    
    func testToggleCommentsVisibility() {
        let viewModel = FeedViewModel(feedUC: MockFeedUseCase())
        let mockDelegate = MockFeedViewDelegate()
        viewModel.delegate = mockDelegate
        
        let initialShowComments = viewModel.showComments
        
        viewModel.toggleCommentsVisibility()
        
        XCTAssertEqual(viewModel.showComments, !initialShowComments)
        XCTAssertEqual(mockDelegate.didToggleCommentsVisibilityTo, !initialShowComments)
    }
}
