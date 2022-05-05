//
//  ResetPasswordViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol ResetPasswordViewModelDelegate {
    var changePassStatus: ReactiveListener<GeneralResult> { get set }
    func webService()
    var validation: ReactiveListener<GeneralResult> { get set }
    func validateTextFields()
    func storeData(text: String?, tag: Int)
    var old: String { get set }
    var pass: String { get set }
    var conf: String { get set }
}

class ResetPasswordViewModel : ResetPasswordViewModelDelegate {
    //MARK:- Reactive Listeners set up
    var validation: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    var changePassStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    //MARK:_ Declaring variables
    var old: String = ""
    var pass: String = ""
    var conf: String = ""
    //MARK:- extract data from textfields
    func storeData(text: String?, tag: Int) {
        switch tag {
        case 1:
            old = text ?? ""
        case 2:
            pass = text ?? ""
        case 3:
            conf = text ?? ""
        default:
            break
        }
    }
    //MARK:- Validation of textfields
    func validateTextFields() {
        if ((old.isEmpty) || (pass.isEmpty) || (conf.isEmpty)) {
            validation.value = .failure(message: Alert.emptyFieldSub.rawValue)
        }
        else if isValidPassword(password: pass) == false {
            validation.value = .failure(message: Alert.passwordSub.rawValue)
        }
        else if pass != conf {
            validation.value = .failure(message: Alert.confpassSub.rawValue)
        }
        else {
            validation.value = .success
        }
    }
    //MARK:- webService calling for changing password
    func webService() {
        UserService.changePassword(old: old, password: pass, conf: conf) { (response) in
            switch response {
            case .success(let value):
                print(value)
                self.changePassStatus.value = .success
            case .failure(let error):
                self.changePassStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
