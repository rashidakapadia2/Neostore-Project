//
//  EditProfileViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol EditProfileViewModelDelegate {
    func storeData(text: String?, tag: Int)
    var validation: ReactiveListener<GeneralResult> { get set }
    func validateTextfields()
    var userUpdateStatus: ReactiveListener<GeneralResult> { get set }
    func webService()
    var fn: String { get set }
    var ln: String { get set }
    var em: String { get set }
    var dob: String { get set }
    //var pp: String { get set }
    var num: String { get set }
}

class EditProfileViewModel : EditProfileViewModelDelegate {
    //MARK:- Reactive Listeners set up
    var validation: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    var userUpdateStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    //MARK:- Declaring variables
    var fn: String = ""
    var ln: String = ""
    var em: String = ""
    var dob: String = ""
    //var pp: String = ""
    var num: String = ""
    
    //MARK:- Validating TextFields
    func validateTextfields() {
        if em.isEmpty || dob.isEmpty || num.isEmpty {
            validation.value = .failure(message: Alert.emptyFieldSub.rawValue)
        }
        else if !isValidEmail(email: em) {
            validation.value = .failure(message: Alert.emailSub.rawValue)
        }
        else if !isValidNumber(number: num) {
            validation.value = .failure(message: Alert.numSub.rawValue)
        }
        else if num.count != 10 {
            validation.value = .failure(message: Alert.phoneSub.rawValue)
        }
        else {
            validation.value = .success
        }
    }
    // Extract Text from fields
    func storeData(text: String?, tag: Int) {
        switch tag {
        case 1:
            fn = text ?? ""
        case 2:
            ln = text ?? ""
        case 3:
            em = text ?? ""
        case 4:
            dob = text ?? ""
        case 5:
            num = text ?? ""
        default:
            break
        }
    }
    //MARK:- func call for webservice
    func webService() {
        UserService.updateUserDetails(fn: fn, ln: ln, em: em, dob: dob, num: num) { (response) in
            switch response {
            case .success(_):
                self.userUpdateStatus.value = .success
            case .failure(let error):
                self.userUpdateStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
