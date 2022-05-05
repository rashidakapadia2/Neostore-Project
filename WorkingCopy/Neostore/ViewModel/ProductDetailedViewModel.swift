//
//  ProductDetailedViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol ProductDetailedViewModelDelegate {
    var product_detail: ProductDetail? { get set }
    var productDetailStatus: ReactiveListener<GeneralResult> { get set }
    func webService(prodID: Int)
}

class ProductDetailedViewModel : ProductDetailedViewModelDelegate {
    var product_detail: ProductDetail?
    var productDetailStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    
    func webService(prodID: Int) {
        ProductService.prodDetail(prodID: "\(prodID)") { (result) in
            switch result {
            case .success(let value):
                self.product_detail = value.data
                self.productDetailStatus.value = .success
            case .failure(let error):
                self.productDetailStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
