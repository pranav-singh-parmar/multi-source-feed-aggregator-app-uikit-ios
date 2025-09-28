//
//  PostCacheDataSourceTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 29/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class PostCacheDataSourceIMPLTests: XCTestCase {

    private var cacheDS: PostCacheDataSourceIMPL!
    
    override func setUp() {
        super.setUp()
        cacheDS = PostCacheDataSourceIMPL()
        UserDefaults.cachedPosts = nil
    }
    
    override func tearDown() {
        UserDefaults.cachedPosts = nil
        cacheDS = nil
        super.tearDown()
    }

    func testSavePostsStoresPosts() {
        let posts = [PostModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "savePosts completes")
        
        cacheDS.savePosts(posts) { success in
            XCTAssertTrue(success)
            XCTAssertEqual(UserDefaults.cachedPosts?.count, 1)
            XCTAssertEqual(UserDefaults.cachedPosts?.first?.id, PostModel.getTestModelOneID)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetPostsReturnsStoredPosts() {
        UserDefaults.cachedPosts = [PostModel.getTestModelTwo]
        let expectation = XCTestExpectation(description: "getPosts completes")
        
        cacheDS.getPosts { posts in
            XCTAssertNotNil(posts)
            XCTAssertEqual(posts?.count, 1)
            XCTAssertEqual(posts?.first?.id, PostModel.getTestModelTwoID)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetPostsReturnsNilIfNoPosts() {
        UserDefaults.cachedPosts = nil
        let expectation = XCTestExpectation(description: "getPosts completes")
        
        cacheDS.getPosts { posts in
            XCTAssertNil(posts)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testClearRemovesPosts() {
        UserDefaults.cachedPosts = [PostModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "clear completes")
        
        cacheDS.clear {
            XCTAssertNil(UserDefaults.cachedPosts)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
