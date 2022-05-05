//
//  HomeScreenViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol HomeScreenViewModelDelegate {
    func gettingCategoryID(idx: Int) -> (String)
}

class HomeScreenViewModel: HomeScreenViewModelDelegate {
    func gettingCategoryID(idx: Int) -> (String) {
            if idx == 0 {
                return "1"
            }
            else if idx == 1 {
                return "3"
            }
            else if idx == 2 {
                return "2"
            }
            else {
                return "4"
            }
        }
    
    
}
