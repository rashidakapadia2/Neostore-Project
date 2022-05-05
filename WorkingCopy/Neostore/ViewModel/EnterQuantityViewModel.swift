//
//  EnterQuantityViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol EnterQuantityViewModelDelegate {
    var validation: ReactiveListener<GeneralResult> { get set }
    func validateQnty(qnty: String)
    var addToCartStatus: ReactiveListener<GeneralResult> { get set }
    func webService(prod_ID: Int, qnty: Int)
}

class EnterQuantityViewModel : EnterQuantityViewModelDelegate {
    //MARK:- Deining Reactive listeners
    var addToCartStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    var validation: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    
    //MARK:- Validating qnty textfield
    func validateQnty(qnty: String) {
        if qnty.isEmpty {
            self.validation.value = .failure(message: GeneralAlert.emptyQnty.rawValue)
        }
        else if isValidQnty(number: qnty) == false {
            self.validation.value = .failure(message: GeneralAlert.notValidQnty.rawValue)
        }
        else {
            self.validation.value = .success
        }
    }
    
    //MARK:- webService call for adding products to cart
    func webService(prod_ID: Int, qnty: Int) {
        CartService.addToCart(product_id: prod_ID, quantity: qnty) { (result) in
            switch result {
            case .success(_) :
                self.addToCartStatus.value = .success
            case .failure(let error) :
                self.addToCartStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
