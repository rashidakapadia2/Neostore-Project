//
//  AddressListViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation
import UIKit

protocol AddressListViewModelDelegate {
    func webServiceForName()
    var getNameStatus: ReactiveListener<GeneralResult> { get set }
    func webService()
    var placeOrderStatus: ReactiveListener<GeneralResult> { get set }
    func getNoOfRows() -> Int
    func getItemAtIdx(idx: Int) -> String
    var address: [String] { get set }
    var userContainer: UserDetail? { get set }
    var currentIndex: Int { get set }
}

class AddressListViewModel : AddressListViewModelDelegate {
    var currentIndex: Int = 0
    var userContainer: UserDetail?
    //MARK:- Reactive Listeners
    var getNameStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    var placeOrderStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    //MARK:- Functions for tableView
    func getNoOfRows() -> Int {
        address.count
    }
    func getItemAtIdx(idx: Int) -> String {
        address[idx]
    }
    //MARK:- getting address from UserDefaults
    var address = UserDefaults.standard.getAllAddress()
    
    //MARK:- WebService call for fetching name and surname
    func webServiceForName() {
        UserService.fetchUser { (result) in
            switch result {
            case .success(let value) :
                self.userContainer = value.data?.user_data
                self.getNameStatus.value = .success
            case .failure(let error) :
                self.getNameStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
    //MARK:- Calling WebService for placing order
    func webService() {
        OrderService.setOrder(address: address[currentIndex]) { (result) in
            switch result {
            case .success(let value) :
                print(value)
                self.placeOrderStatus.value = .success
            case .failure(let error) :
                self.placeOrderStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
