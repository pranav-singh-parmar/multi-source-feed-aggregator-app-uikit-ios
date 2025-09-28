//
//  FeedUseCaseIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation
import UIKit

class FeedUseCaseIMPL: FeedUseCase {
    
    //MARK: Properties
    private let postREPO: PostRepository
    private let userREPO: UserRepository
    private let postCommentREPO: PostCommentRepository
    private let postImageREPO: PostImageRepository
    
    private var postResult: RepositoryResult<[PostModel]>?
    private var userResult: RepositoryResult<[UserModel]>?
    private var postCommentResult: RepositoryResult<[PostCommentModel]>?
    private var postImageResult: RepositoryResult<[PostImageModel]>?
    
    private var totalPosts = 0
    
    //MARK: Init
    init(postREPO: PostRepository = PostRepositoryIMPL(),
         userREPO: UserRepository = UserRepositoryIMPL(),
         postCommentREPO: PostCommentRepository = PostCommentRepositoryIMPL(),
         postImageREPO: PostImageRepository = PostImageRepositoryIMPL()) {
        self.postREPO = postREPO
        self.userREPO = userREPO
        self.postCommentREPO = postCommentREPO
        self.postImageREPO = postImageREPO
    }
    
    //MARK: Protocol Implementation
    func fetchDetails(withLimit limit: Int,
                      completion: @escaping (UseCaseResult<Feed>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        postREPO.getPosts { [weak self] result in
            guard let self else { return }
            
            postResult = result
            totalPosts = ((try? postResult?.get().data) ?? []).count
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        userREPO.getUsers { [weak self] result in
            guard let self else { return }
            
            userResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        postCommentREPO.getComments { [weak self] result in
            guard let self else { return }
            
            postCommentResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        postImageREPO.getImages { [weak self] result in
            guard let self else { return }
            
            postImageResult = result
            dispatchGroup.leave()
        }
        
        /// Called once all API calls are done
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            if case .failure(let error) = postResult {
                completion(.failure(getFeedUseCaseError(from: error)))
                return
            }
            
            if case .failure(let error) = userResult {
                completion(.failure(getFeedUseCaseError(from: error)))
                return
            }
            
            if case .failure(let error) = postCommentResult {
                completion(.failure(getFeedUseCaseError(from: error)))
                return
            }
            
            if case .failure(let error) = postImageResult {
                completion(.failure(getFeedUseCaseError(from: error)))
                return
            }
            
            let isPostsFromCache = (try? postResult?.get().isFromCache) ?? false
            let isUsersFromCache = (try? userResult?.get().isFromCache) ?? false
            let isPostCommentsFromCache = (try? postCommentResult?.get().isFromCache) ?? false
            let isPostImageFromCache = (try? postCommentResult?.get().isFromCache) ?? false
            let isFromCache = isPostsFromCache || isUsersFromCache || isPostCommentsFromCache || isPostImageFromCache
            
            let feedItems = paginate(from: 0, withLimit: limit)
            completion(.success(UseCaseSuccess(data: Feed(totalPosts: totalPosts,
                                                          items: feedItems),
                                               isFromCache: isFromCache)))
        }
    }
    
    private func getFeedUseCaseError(from error: RepositoryError) -> UseCaseError {
        switch error {
        case .apiDataSourceError(let apiDataSourceError):
            switch apiDataSourceError {
            case .apiRequestError(let apiRequestError, let errorMessage):
                switch apiRequestError {
                case .internetNotConnected:
                    return .internetNotConnected
                default:
                    return .somethingWentWrong(errorMessage: errorMessage)
                }
            default:
                return .somethingWentWrong(errorMessage: nil)
            }
        }
    }
    
    func paginate(from start: Int, withLimit limit: Int) -> [FeedItem] {
        let posts = (try? postResult?.get().data) ?? []
        let users = (try? userResult?.get().data) ?? []
        let comments = (try? postCommentResult?.get().data) ?? []
        // let images = (try? postImageResult?.get().data) ?? []
        
        let usersDict = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
        let commentsDict = Dictionary(grouping: comments, by: { $0.postID })
        //let imagesDict = Dictionary(grouping: images, by: { $0.albumID })
        
        let end = min(start + limit, posts.count)
        guard start < end else { return [] }

        let pagedPosts = posts[start..<end]

        return pagedPosts.map { post in
            let user = usersDict[post.userID]
            let postComments = commentsDict[post.id] ?? []
            
            //let postImages = imagesDict[post.id] ?? []
            //https://dummyjson.com/docs/image
            let nameToShow = (user?.name ?? "Dummy Image") + " PostID: " + String(post.id ?? 0)
            let parts = nameToShow.components(separatedBy: " ")
                .compactMap { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            let hexString = UIColor.from(id: post.id ?? 0).hexString.replacingOccurrences(of: "#", with: "")
            let imageURL = "https://dummyjson.com/image/400x400/\(hexString)?type=webp&text=\(parts.joined(separator: "+"))"
            
            return FeedItem(post: post,
                            user: user,
                            comments: postComments,
                            dummyImage: imageURL
                            //images: postImages
            )
        }
    }
}

//MARK: - For TestCases
extension FeedUseCaseIMPL {
    func setValueForTesting(
        postResult: RepositoryResult<[PostModel]>,
        userResult: RepositoryResult<[UserModel]>,
        postCommentResult: RepositoryResult<[PostCommentModel]>,
        postImageResult: RepositoryResult<[PostImageModel]>
    ) {
        #if DEBUG
        self.postResult = postResult
        self.userResult = userResult
        self.postCommentResult = postCommentResult
        self.postImageResult = postImageResult
        #endif
    }
}
