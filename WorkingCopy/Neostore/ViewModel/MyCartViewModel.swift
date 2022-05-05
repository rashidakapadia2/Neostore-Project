//
//  MyCartViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol MyCartViewModelDelegate {
    func getNoOfRows() -> Int
    var list: [CartList] { get set }
    var cartItemsListStatus: ReactiveListener<GeneralResult> { get set }
    func listWebService()
    var editCartStatus: ReactiveListener<GeneralResult> { get set }
    func editWebService(prod_id: Int, qnty: Int)
    var deleteCartItemsStatus: ReactiveListener<GeneralResult> { get set }
    func deleteWebService(prod_id: Int)
    var totalCost: Int { get set }
}

class MyCartViewModel : MyCartViewModelDelegate {
    //MARK:- To display no of rows in Table View
    func getNoOfRows() -> Int{
        return list.count
    }
    
    var list: [CartList] = []
    
    //MARK:- Defining reactive listeners
    var editCartStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    var deleteCartItemsStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    var cartItemsListStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    
    var totalCost: Int = 0
    
    //MARK:- Calling WebServices to list cart items
    func listWebService() {
        CartService.listCartItems { (response) in
            switch response {
            case .success(let value):
                self.list = value.data ?? []
                self.totalCost = value.total ?? 0
                self.cartItemsListStatus.value = .success
            case .failure(let error):
                self.cartItemsListStatus.value = .failure(message: error.localizedDescription)
            }
            
        }
    }
    //MARK:- Calling webServices to edit cart data
    func editWebService(prod_id: Int, qnty: Int) {
        CartService.editCart(product_id: prod_id, quantity: qnty){ (result) in
            switch result {
            case .success(_):
                self.editCartStatus.value = .success
            case .failure(let error):
                self.editCartStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
//MARK:- Calling webServices to delete cart data
    func deleteWebService(prod_id: Int) {
        CartService.deleteCart(product_id: prod_id){ (result) in
            switch result {
            case .success(_):
                self.deleteCartItemsStatus.value = .success
            case .failure(let error):
                self.deleteCartItemsStatus.value = .failure(message: error.localizedDescription)
        }
    }
}
}
