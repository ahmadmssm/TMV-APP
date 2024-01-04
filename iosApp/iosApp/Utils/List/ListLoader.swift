//
//  ListLoader.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 29/09/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import kmmSharedModule

class ListLoader<T: Diffable> {
    
    private var list: [T] = []
    private var isLoading = false {
        willSet {
            if !newValue {
                self.hideLoadingAction?()
            }
        }
    }
    private var showLoadingAction: (() -> ())? = nil
    private var hideLoadingAction: (() -> ())? = nil
    private var shouldShowEmptyView: ((Bool) -> ())? = nil
    //
    private let showErrorAction: ((String) -> ())
    private let didFetchItemsAction: ((_ items: [T]) -> ())
    private let listFetcher: (@escaping ([T]) -> (), @escaping (String) -> ()) -> ()
    
    init(listFetcher: @escaping (@escaping ([T]) -> (), @escaping (String) -> ()) -> (),
         didFetchItemsAction: @escaping (_ items: [T]) -> (),
         showErrorAction: @escaping (String) -> ()) {
        self.listFetcher = listFetcher
        self.didFetchItemsAction = didFetchItemsAction
        self.showErrorAction = showErrorAction
    }
    
    func showLoadingAction(action: @escaping () -> ()) -> ListLoader {
        self.showLoadingAction = action
        return self
    }
    
    func hideLoadingAction(action: @escaping () -> ()) -> ListLoader {
        self.hideLoadingAction = action
        return self
    }
    
    func shouldShowEmptyView(action: @escaping (Bool) -> ()) -> ListLoader {
        self.shouldShowEmptyView = action
        return self
    }
    
    func reloadFromScratch(resetAction: () -> ()) {
        resetAction()
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
                    if !$0.isEmpty {
                        self.list.append(contentsOf: $0)
                    }
                    self.shouldShowEmptyView?($0.isEmpty)
                    self.isLoading = false
                    self.didFetchItemsAction($0)
                }
            }, { [weak self] in
                self?.isLoading = false
                self?.showErrorAction($0)
            })
        }
    }
}
