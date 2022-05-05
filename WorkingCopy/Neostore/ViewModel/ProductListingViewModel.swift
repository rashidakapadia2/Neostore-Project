//
//  ProductListingViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol ProductListingViewModelDelegate {
    var productListStatus: ReactiveListener<GeneralResult> { get set }
    var products: [ProductDatas] { get set }
    func webService(categoryId: String)
    
    // Table View Functions
    func getTotalNumOfRows() -> Int
    func getItemAtIndexAt(idx: Int) -> ProductDatas
}

class ProductListingViewModel : ProductListingViewModelDelegate {
    //MARK:- To display info in table view
    func getTotalNumOfRows() -> Int {
        return products.count
    }
    func getItemAtIndexAt(idx: Int) -> ProductDatas {
        return products[idx]
    }
    //MARK:- Declaring variable to call object
    var products: [ProductDatas] = []
    //MARK:- Reactive Listener set up
    var productListStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    
    //MARK:- Webservices call
    func webService(categoryId: String) {
        ProductService.prodList(categoryID: categoryId) { (result) in
            switch result {
            case .success(let value):
                self.products.append(contentsOf: value.data ?? [])
                self.productListStatus.value = .success
            case .failure(let error):
                self.productListStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
