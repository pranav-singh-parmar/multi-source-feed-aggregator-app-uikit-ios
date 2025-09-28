//
//  PostImageCacheDataSourceTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 29/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class PostImageCacheDataSourceTests: XCTestCase {

    private var cacheDS: PostImageCacheDataSourceIMPL!
    
    override func setUp() {
        super.setUp()
        cacheDS = PostImageCacheDataSourceIMPL()
        UserDefaults.cachedPostImages = nil
    }
    
    override func tearDown() {
        UserDefaults.cachedPostImages = nil
        cacheDS = nil
        super.tearDown()
    }

    func testSaveCommentsStoresComments() {
        let postImages = [PostImageModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "savePostImages completes")
        
        cacheDS.savePostImages(postImages) { success in
            XCTAssertTrue(success)
            XCTAssertEqual(UserDefaults.cachedPostImages?.count, 1)
            XCTAssertEqual(UserDefaults.cachedPostImages?.first?.id, PostImageModel.getTestModelOneID)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetImagesReturnsStoredImages() {
        UserDefaults.cachedPostImages = [PostImageModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "getPostImages completes")
        
        cacheDS.getPostImages { images in
            XCTAssertNotNil(images)
            XCTAssertEqual(images?.count, 1)
            XCTAssertEqual(images?.first?.id, PostImageModel.getTestModelOneID)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetImagesReturnsNilIfNoImages() {
        UserDefaults.cachedPostImages = nil
        let expectation = XCTestExpectation(description: "getPostImages completes")
        
        cacheDS.getPostImages { images in
            XCTAssertNil(images)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testClearRemovesImages() {
        UserDefaults.cachedPostImages = [PostImageModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "clear completes")
        
        cacheDS.clear {
            XCTAssertNil(UserDefaults.cachedPostImages)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
