//
//  PagableListLoader.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 29/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import kmmSharedModule

class PagableListLoader<T: Diffable> {
    
    private var list: [T] = []
    private var isLoading = false {
        willSet {
            if !newValue {
                self.hideLoadingAction?()
            }
        }
    }
    private var noMoreItemsToLoad = false
    private var showLoadingAction: (() -> ())? = nil
    private var hideLoadingAction: (() -> ())? = nil
    private var shouldShowEmptyView: ((Bool) -> ())? = nil
    private var noMoreItemsToLoadAction: (() -> ())? = nil
    //
    private let paginationThreshold: Int
    private let showErrorAction: ((String) -> ())
    private let didFetchItemsAction: ((_ items: [T]) -> ())
    private let listFetcher: (@escaping (KotlinBoolean, [T]) -> (), @escaping (String) -> ()) -> ()
    
    init(paginationThreshold: Int = 1,
         listFetcher: @escaping (@escaping (KotlinBoolean, [T]) -> (), @escaping (String) -> ()) -> (),
         didFetchItemsAction: @escaping (_ items: [T]) -> (),
         showErrorAction: @escaping (String) -> ()) {
        self.paginationThreshold = paginationThreshold
        self.listFetcher = listFetcher
        self.didFetchItemsAction = didFetchItemsAction
        self.showErrorAction = showErrorAction
    }
    
    func showLoadingAction(action: @escaping () -> ()) -> PagableListLoader {
        self.showLoadingAction = action
        return self
    }
    
    func hideLoadingAction(action: @escaping () -> ()) -> PagableListLoader {
        self.hideLoadingAction = action
        return self
    }
    
    func noMoreItemsToLoadAction(action: @escaping () -> ()) -> PagableListLoader {
        self.noMoreItemsToLoadAction = action
        return self
    }
    
    func shouldShowEmptyView(action: @escaping (Bool) -> ()) -> PagableListLoader {
        self.shouldShowEmptyView = action
        return self
    }
    
    func loadMoreIfNeeded(item: T) {
        let thresholdIndex = self.list.count - paginationThreshold
        if let indexOfLastVisibleItem = self.list.firstIndex(where: { $0.isTheSameAs(item) }), thresholdIndex == indexOfLastVisibleItem {
            if !noMoreItemsToLoad {
                self.fetchItems()
            }
            else {
                // This condition to avoide showing no more items to load view if the list has dew items and the users has not requested load more.
                if self.list.count > 5 {
                    self.noMoreItemsToLoadAction?()
                }
            }
        }
    }
    
    func reloadFromScratch(resetPaginationAction: () -> ()) {
        resetPaginationAction()
        self.noMoreItemsToLoad = false
        self.list.removeAll()
        self.fetchItems()
    }
    
    func fetchItems() {
        // To Avoid duplicate API call
        if !self.isLoading {
            // If loading from scratch or for the first time, then no need to show the bottom loader.
            if !self.list.isEmpty {
                self.showLoadingAction?()
            }
            self.isLoading = true
            self.listFetcher({ [weak self] in
                if let self {
                    if $0.boolValue == true {
                        self.noMoreItemsToLoad = true
                    }
                    if !$1.isEmpty {
                        self.list.append(contentsOf: $1)
                    }
                    self.shouldShowEmptyView?($1.isEmpty)
                    self.isLoading = false
                    self.didFetchItemsAction($1)
                }
            }, { [weak self] in
                self?.isLoading = false
                self?.showErrorAction($0)
            })
        }
    }
}
