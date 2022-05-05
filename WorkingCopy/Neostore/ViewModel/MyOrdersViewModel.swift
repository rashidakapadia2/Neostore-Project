//
//  MyOrdersViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol MyOrdersViewModelDelegate {
    func getTotalNumOfRows() -> Int
    func getItemAtIndexAt(idx: Int) -> Orderlist
    func webService()
    var orderList: [Orderlist] { get set }
    var orderListStatus: ReactiveListener<GeneralResult> { get set }
}

class MyOrdersViewModel : MyOrdersViewModelDelegate {
    //MARK:- func to display items in Table View
    func getTotalNumOfRows() -> Int {
        return orderList.count
    }
    func getItemAtIndexAt(idx: Int) -> Orderlist {
        return orderList[idx]
    }
    //MARK:- Defining Reactive Listeners
    var orderListStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    //MARK:- declaring variable and giving it an object type
    var orderList: [Orderlist] = []
    
    //MARK:- Calling WebService for getting order list
    func webService() {
        OrderService.getOrderLists { (result) in
            switch result {
            case .success(let value):
                self.orderList.append(contentsOf: value.data ?? [] )
                print(self.orderList)
                self.orderListStatus.value = .success
            case .failure(let error):
                self.orderListStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
