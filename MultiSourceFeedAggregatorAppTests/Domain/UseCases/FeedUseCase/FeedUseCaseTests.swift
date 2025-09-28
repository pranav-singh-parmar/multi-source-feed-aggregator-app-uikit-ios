//
//  FeedUseCaseTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class FeedUseCaseTests: XCTestCase {
    
    func testFetchDetailsReturnsFeedOnSuccess() {
        let mockPosts = [PostModel.getTestModelOne]
        let mockUsers = [UserModel.getTestModelOne]
        let mockPostComments = [PostCommentModel.getTestModelOne]
        let mockPostImages = [PostImageModel.getTestModelOne]
        
        let postRepo = MockPostRepository()
        postRepo.result = .success(mockPosts)
        
        let userRepo = MockUserRepository()
        userRepo.result = .success(mockUsers)
        
        let commentRepo = MockPostCommentRepository()
        commentRepo.result = .success(mockPostComments)
        
        let imageRepo = MockPostImageRepository()
        imageRepo.result = .success(mockPostImages)
        
        let useCase = FeedUseCaseIMPL(
            postREPO: postRepo,
            userREPO: userRepo,
            postCommentREPO: commentRepo,
            postImageREPO: imageRepo
        )
        
        let expectation = XCTestExpectation(description: "fetchDetails completes")
        
        useCase.fetchDetails(withLimit: 10) { result in
            switch result {
            case .success(let feed):
                XCTAssertEqual(feed.totalPosts, 1)
                XCTAssertEqual(feed.items?.count, 1)
                XCTAssertEqual(feed.items?.first?.post?.id, PostModel.getTestModelOneID)
                XCTAssertEqual(feed.items?.first?.user?.id, UserModel.getTestModelOneID)
                XCTAssertEqual(feed.items?.first?.comments?.count, 1)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchDetailsReturnsFailureWhenPostRepoFails() {
        let postRepo = MockPostRepository()
        postRepo.result = .failure(.apiDataSourceError(.apiRequestError(.internetNotConnected, nil)))
        
        let userRepo = MockUserRepository()
        userRepo.result = .success([])
        
        let commentRepo = MockPostCommentRepository()
        commentRepo.result = .success([])
        
        let imageRepo = MockPostImageRepository()
        imageRepo.result = .success([])
        
        let useCase = FeedUseCaseIMPL(
            postREPO: postRepo,
            userREPO: userRepo,
            postCommentREPO: commentRepo,
            postImageREPO: imageRepo
        )
        
        let expectation = XCTestExpectation(description: "fetchDetails completes")
        
        useCase.fetchDetails(withLimit: 10) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                if case .internetNotConnected = error {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("Expected internetNotConnected error")
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
