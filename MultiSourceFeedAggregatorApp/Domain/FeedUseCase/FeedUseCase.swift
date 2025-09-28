//
//  FeedUseCase.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class FeedUseCase {
    
    private let postREPO = PostRepository(dataSource: PostAPIDataSource())
    private let userREPO = UserRepository(dataSource: UserAPIDataSource())
    private let postCommentREPO = PostCommentRepository(dataSource: PostCommentAPIDataSource())
    private let postImageREPO = PostImageRepository(dataSource: PostImageAPIDataSource())
    
    private var postResult: RepositoryResult<[PostModel]>?
    private var totalPosts = 0
    private var userResult: RepositoryResult<[UserModel]>?
    private var postCommentResult: RepositoryResult<[PostCommentModel]>?
    private var postImageResult: RepositoryResult<[PostImageModel]>?
    
    func fetchDetails(withLimit limit: Int,
                      completion: @escaping (Result<Feed, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        postREPO.getPosts { [weak self] result in
            guard let self else { return }
            
            postResult = result
            totalPosts = ((try? postResult?.get()) ?? []).count
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
            
            if case .failure(let e) = postResult {
                print("Posts API failed: \(e.localizedDescription)")
            }
            
            if case .failure(let e) = postResult {
                print("Posts API failed: \(e.localizedDescription)")
            }
            
            if case .failure(let e) = postResult {
                print("Posts API failed: \(e.localizedDescription)")
            }
            
            if case .failure(let e) = postResult {
                print("Posts API failed: \(e.localizedDescription)")
            }
            
            let feedItems = paginate(from: 0, withLimit: limit)
            completion(.success(Feed(totalPosts: totalPosts,
                                     items: feedItems)))
        }
    }
    
    func paginate(from start: Int, withLimit limit: Int) -> [FeedItem] {
        let posts = (try? postResult?.get()) ?? []
        let users = (try? userResult?.get()) ?? []
        let comments = (try? postCommentResult?.get()) ?? []
        let images = (try? postImageResult?.get()) ?? []
        
        let usersDict = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
        let commentsDict = Dictionary(grouping: comments, by: { $0.postID })
        let imagesDict = Dictionary(grouping: images, by: { $0.albumID })
        
        let end = min(start + limit, posts.count)
        guard start < end else { return [] }

        let pagedPosts = posts[start..<end]

        return pagedPosts.map { post in
            let user = usersDict[post.userID]
            let postComments = commentsDict[post.id] ?? []
            let postImages = imagesDict[post.id] ?? []
            return FeedItem(post: post,
                            user: user,
                            comments: postComments,
                            images: postImages)
        }
    }
}
