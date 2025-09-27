//
//  FeedViewModel.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

protocol ABC: AnyObject {
    func fetchingDetails()
    func reloadFeeds()
    func insertedFeedsAt(indexPath: IndexPath)
}

class FeedViewModel {
    
    private(set) var getAnimeListAS: APIRequestStatus = .notConsumedOnce
    
    private let feedUC = FeedUseCase()
    
    private let limit = 10
    private(set) var feed = [FeedModel]()
    private var total = 0
    private var currentLength = 0
    
    weak var delegate: (any ABC)? = nil
    
    var fetchedAllData: Bool {
        return total <= currentLength
    }
    
    func isLastIndex(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == currentLength - 1
    }
    
    func paginateWithIndex(_ indexPath: IndexPath) {
        if getAnimeListAS != .isBeingConsumed &&
            isLastIndex(indexPath) &&
            !fetchedAllData {
            let feed = feedUC.paginate(from: currentLength, withLimit: limit)
            self.feed.append(contentsOf: feed)
            self.currentLength = feed.count
            self.delegate?.insertedFeedsAt(indexPath: IndexPath(row: currentLength,
                                                                section: 0))
        }
    }
    
    func fetchFeedList() {
        feedUC.fetchDetails(withLimit: limit) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let feed):
                self.feed.removeAll()
                self.feed.append(contentsOf: feed)
                self.currentLength = feed.count
                self.delegate?.reloadFeeds()
            case .failure(let error):
                break
            }
        }
    }
}
