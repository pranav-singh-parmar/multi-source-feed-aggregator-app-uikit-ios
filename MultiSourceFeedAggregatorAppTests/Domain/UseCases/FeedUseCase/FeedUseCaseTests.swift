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
        postRepo.result = .success(RepositorySuccess(data: mockPosts, isFromCache: false))

        let userRepo = MockUserRepository()
        userRepo.result = .success(RepositorySuccess(data: mockUsers, isFromCache: false))

        let commentRepo = MockPostCommentRepository()
        commentRepo.result = .success(RepositorySuccess(data: mockPostComments, isFromCache: false))

        let imageRepo = MockPostImageRepository()
        imageRepo.result = .success(RepositorySuccess(data: mockPostImages, isFromCache: false))

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
                XCTAssertEqual(feed.data.totalPosts, 1)
                XCTAssertEqual(feed.data.items?.count, 1)
                XCTAssertEqual(feed.data.items?.first?.post?.id, PostModel.getTestModelOneID)
                XCTAssertEqual(feed.data.items?.first?.user?.id, UserModel.getTestModelOneID)
                XCTAssertEqual(feed.data.items?.first?.comments?.count, 1)
                XCTAssertFalse(feed.isFromCache)
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
        userRepo.result = .success(RepositorySuccess(data: [], isFromCache: false))

        let commentRepo = MockPostCommentRepository()
        commentRepo.result = .success(RepositorySuccess(data: [], isFromCache: false))

        let imageRepo = MockPostImageRepository()
        imageRepo.result = .success(RepositorySuccess(data: [], isFromCache: false))

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

    func testFetchDetailsReturnsFailureWhenUserRepoFails() {
        let postRepo = MockPostRepository()
        postRepo.result = .success(RepositorySuccess(data: [PostModel.getTestModelOne], isFromCache: false))

        let userRepo = MockUserRepository()
        userRepo.result = .failure(.apiDataSourceError(.apiRequestError(.serverError(statusCode: 500), nil)))

        let commentRepo = MockPostCommentRepository()
        commentRepo.result = .success(RepositorySuccess(data: [], isFromCache: false))

        let imageRepo = MockPostImageRepository()
        imageRepo.result = .success(RepositorySuccess(data: [], isFromCache: false))

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
                if case .somethingWentWrong = error {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("Expected somethingWentWrong error")
                }
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testFetchDetailsReturnsFromCacheWhenRepositoriesReturnCachedData() {
        let postRepo = MockPostRepository()
        postRepo.result = .success(RepositorySuccess(data: [PostModel.getTestModelOne], isFromCache: true))

        let userRepo = MockUserRepository()
        userRepo.result = .success(RepositorySuccess(data: [UserModel.getTestModelOne], isFromCache: false))

        let commentRepo = MockPostCommentRepository()
        commentRepo.result = .success(RepositorySuccess(data: [PostCommentModel.getTestModelOne], isFromCache: false))

        let imageRepo = MockPostImageRepository()
        imageRepo.result = .success(RepositorySuccess(data: [PostImageModel.getTestModelOne], isFromCache: false))

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
                XCTAssertTrue(feed.isFromCache)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testPaginateReturnsEmptyIfStartExceedsPosts() {
        let useCase = FeedUseCaseIMPL(
            postREPO: MockPostRepository(),
            userREPO: MockUserRepository(),
            postCommentREPO: MockPostCommentRepository(),
            postImageREPO: MockPostImageRepository()
        )

        /// Mock empty results
        useCase.setValueForTesting(postResult: .success(RepositorySuccess(data: [], isFromCache: false)),
                                   userResult: .success(RepositorySuccess(data: [], isFromCache: false)),
                                   postCommentResult: .success(RepositorySuccess(data: [], isFromCache: false)),
                                   postImageResult: .success(RepositorySuccess(data: [], isFromCache: false)))

        let feedItems = useCase.paginate(from: 10, withLimit: 10)
        XCTAssertTrue(feedItems.isEmpty)
    }
}
