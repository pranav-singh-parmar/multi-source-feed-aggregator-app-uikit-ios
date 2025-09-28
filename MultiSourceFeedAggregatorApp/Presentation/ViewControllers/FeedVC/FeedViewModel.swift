//
//  FeedViewModel.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class FeedViewModel {
    //MARK: Properties
    private(set) var getPostsAS: APIRequestStatus = .notConsumedOnce
    
    private let feedUC: any FeedUseCase
    
    private let limit = 10
    private(set) var feedItems = [FeedItem]()
    private var total = 0
    private(set) var currentLength = 0
    private(set) var showComments = true
    
    weak var delegate: (any FeedViewDelegate)? = nil
    
    //MARK: Init
    init(feedUC: any FeedUseCase = FeedUseCaseIMPL()) {
        self.feedUC = feedUC
    }
    
    //MARK: Pagination Related
    var fetchedAllData: Bool {
        return total <= currentLength
    }
    
    func isLastIndex(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == currentLength - 1
    }
    
    func paginateWithIndex(_ indexPath: IndexPath) {
        if getPostsAS != .isBeingConsumed &&
            isLastIndex(indexPath) &&
            !fetchedAllData {
            getPostsAS = .isBeingConsumed
            
            let previousLength = currentLength
            let feed = feedUC.paginate(from: currentLength, withLimit: limit)
            self.feedItems.append(contentsOf: feed)
            self.currentLength = self.feedItems.count
            let indexPaths = (previousLength..<currentLength).map { IndexPath(row: $0, section: 0) }
            
            getPostsAS = .consumedWithSuccess
            self.delegate?.didInsertFeeds(at: indexPaths)
        }
    }
    
    //MARK: Toggle Comments Visibility
    func toggleCommentsVisibility() {
        showComments.toggle()
        delegate?.didToggleCommentsVisibility(to: showComments)
    }
    
    //MARK: Fetch Feed from Data Source
    func fetchFeedList() {
        guard getPostsAS != .isBeingConsumed else {
            return
        }
        
        getPostsAS = .isBeingConsumed
        delegate?.didStartFetchingDetails()
        
        feedUC.fetchDetails(withLimit: limit) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let result):
                self.feedItems.removeAll()
                self.feedItems.append(contentsOf: result.data.items ?? [])
                self.total = result.data.totalPosts ?? 0
                self.currentLength = self.feedItems.count
                
                getPostsAS = .consumedWithSuccess
                self.delegate?.didReloadFeeds(fromCache: result.isFromCache, withError: nil)
            case .failure(let error):
                getPostsAS = .consumedWithError
                self.delegate?.didReloadFeeds(fromCache: false, withError: error)
            }
        }
    }
}

//MARK: - For TestCases
extension FeedViewModel {
    func setFeedItemsForTesting(_ items: [FeedItem], currentLength: Int, total: Int) {
        #if DEBUG
        self.feedItems = items
        self.currentLength = currentLength
        self.total = total
        #endif
    }
}
