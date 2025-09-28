//
//  PostCommentCacheDataSourceTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 29/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class PostCommentCacheDataSourceTests: XCTestCase {

    private var cacheDS: PostCommentCacheDataSourceIMPL!
    
    override func setUp() {
        super.setUp()
        cacheDS = PostCommentCacheDataSourceIMPL()
        UserDefaults.cachedPostComments = nil
    }
    
    override func tearDown() {
        UserDefaults.cachedPostComments = nil
        cacheDS = nil
        super.tearDown()
    }

    func testSaveCommentsStoresComments() {
        let postComments = [PostCommentModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "saveComments completes")
        
        cacheDS.savePostComments(postComments) { success in
            XCTAssertTrue(success)
            XCTAssertEqual(UserDefaults.cachedPostComments?.count, 1)
            XCTAssertEqual(UserDefaults.cachedPostComments?.first?.id, PostCommentModel.getTestModelOneID)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetCommentsReturnsStoredComments() {
        UserDefaults.cachedPostComments = [PostCommentModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "getPostComments completes")
        
        cacheDS.getPostComments { postComments in
            XCTAssertNotNil(postComments)
            XCTAssertEqual(postComments?.count, 1)
            XCTAssertEqual(postComments?.first?.id, PostCommentModel.getTestModelOneID)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetCommentsReturnsNilIfNoComments() {
        UserDefaults.cachedPostComments = nil
        let expectation = XCTestExpectation(description: "getPostComments completes")
        
        cacheDS.getPostComments { postComments in
            XCTAssertNil(postComments)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testClearRemovesComments() {
        UserDefaults.cachedPostComments = [PostCommentModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "clear completes")
        
        cacheDS.clear {
            XCTAssertNil(UserDefaults.cachedPostComments)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
