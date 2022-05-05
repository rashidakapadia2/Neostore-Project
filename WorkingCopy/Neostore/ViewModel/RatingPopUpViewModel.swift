//
//  RatingPopUpViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol RatingPopUpViewModelDelegate {
    var validation: ReactiveListener<GeneralResult> { get set }
    func validateRating(rating: Int)
    func webService(prod_ID: String, rating: Int)
    var ratingStatus: ReactiveListener<GeneralResult> { get set }
}

class RatingPopUpViewModel : RatingPopUpViewModelDelegate {
    //MARK:- Defining reactive listeners
    var ratingStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    var validation: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    
    func validateRating(rating: Int) {
        if rating == 0 {
            self.validation.value = .failure(message: GeneralAlert.ratingZero.rawValue)
        }
        else {
            self.validation.value = .success
        }
    }
    
    //MARK:- WebService Calling for rating
    func webService(prod_ID: String, rating: Int) {
        ProductService.setRating(categoryID: prod_ID, rating: rating) { (result) in
            switch result {
            case .success(_):
                self.ratingStatus.value = .success
            case .failure(let error):
                self.ratingStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
