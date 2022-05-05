//
//  MyAccountViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol MyAccountViewModelDelegate {
    var accDetailStatus: ReactiveListener<GeneralResult> { get set }
    func webService()
    var userContainer: UserDetail? { get set }
}

class MyAccountViewModel : MyAccountViewModelDelegate {
    //MARK:- Declaring variables
    var userContainer: UserDetail?
    //MARK:- Reactive Listener
    var accDetailStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    
    //MARK:- func call for webservice
    func webService() {
        UserService.fetchUser{ (response) in
            switch response {
            case .success(let value):
                self.userContainer = value.data?.user_data
                self.accDetailStatus.value = .success
            case .failure(let error):
                self.accDetailStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
