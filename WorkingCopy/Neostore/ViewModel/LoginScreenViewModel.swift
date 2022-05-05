//
//  LoginScreenViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol LoginScreenViewModelDelegate {
    func validateUsernamePassword()
    func webService()
    var validation : ReactiveListener<GeneralResult> { get set }
    var loginStatus : ReactiveListener<GeneralResult> { get set }
    func storeData(text: String?, tag: Int)
}
enum GeneralResult {
    typealias RawValue = String
    case none
    case success
    case failure(message: String)
}

enum ForgotPassResult {
    typealias RawValue = String
    case none
    case success(message: String)
    case failure(message: String)
}

class LoginScreenViewModel : LoginScreenViewModelDelegate {
    var user: String = ""
    var pass: String = ""
    
    var loginStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    
    var validation: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    
    
    //MARK:- Validating Textfield Input with relevant Constraints
    func validateUsernamePassword() {
        //MARK:- Validating Textfield Input with relevant Constraints
        if ((user.isEmpty) || (pass.isEmpty)) {
            validation.value = .failure(message: Alert.emptyFieldSub.rawValue)
        }
        else if user.count <= 2 {
            validation.value = .failure(message: Alert.emailSub.rawValue)
        }
        else if isValidPassword(password: pass) == false {
            validation.value = .failure(message: Alert.passwordSub.rawValue)
        }
        else {
            validation.value = .success
        }
    }
    
    //MARK:- Calling webservice for User Login Screen
    func webService() {
        UserService.userLogIn(username: user, password: pass) { (response) in
            switch response {
            case .success(let value):
                UserDefaults.standard.setLoggedIn(value: true)
                UserDefaults.standard.setUserToken(value: value.data?.accessToken ?? "")
                print(value)
                self.loginStatus.value = .success
            case .failure(let error):
                self.loginStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
    
    // Extract Text from fields
    func storeData(text: String?, tag: Int) {
        switch tag {
        case 1:
            user = text ?? ""
        case 2:
            pass = text ?? ""
        default:
            break
        }
    }
}




