//
//  PostCommentModelTestExtension.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

extension PostCommentModel {
    static let getTestModelOneID: Int = 1
    static var getTestModelOne: Self {
        return PostCommentModel(
            postID: 1,
            id: getTestModelOneID,
            name: "Test User",
            email: "Test Email",
            body: "Test Body"
        )
    }
}
