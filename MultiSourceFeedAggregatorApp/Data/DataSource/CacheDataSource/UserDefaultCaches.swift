//
//  UserDefaultCaches.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

extension UserDefaults {
    @UserDefault(key: "cached_posts")
    static var cachedPosts: [PostModel]?
    
    @UserDefault(key: "cached_users")
    static var cachedUsers: [UserModel]?
    
    @UserDefault(key: "cached_post_images")
    static var cachedPostImages: [PostImageModel]?
    
    @UserDefault(key: "cached_post_comments")
    static var cachedPostComments: [PostCommentModel]?
}
