//
//  OrderIDViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol OrderIDViewModelDelegate {
    var orderIDStatus: ReactiveListener<GeneralResult> { get set }
    func webService(order_id: String)
    var totalCost: Int { get set }
    var orderDetails: [ResponseOrder] { get set }
    func getTotalNumOfRows() -> Int
    func getItemAtIndexAt(idx: Int) -> ResponseOrder
}

class OrderIDViewModel : OrderIDViewModelDelegate {
    //MARK:- Declaring variables
    var orderDetails: [ResponseOrder] = []
    var totalCost: Int = 0
    //MARK:- Declaring func to display in tableView
    func getTotalNumOfRows() -> Int {
        return orderDetails.count
    }
    func getItemAtIndexAt(idx: Int) -> ResponseOrder {
        return orderDetails[idx]
    }
    //MARK:- Defining Reactive Listener
    var orderIDStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    
    //MARK:- WebService call for getting order details
    func webService(order_id: String) {
        OrderService.getOrderDetail(order_id: order_id) { (response) in
            switch response {
            case .success(let value):
                self.totalCost = value.data.cost
                self.orderDetails.append(contentsOf: value.data.orderDetails)
                print(self.orderDetails)
                self.orderIDStatus.value = .success
            case .failure(let error):
                self.orderIDStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
