//
//  ForgotPasswordScreenViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

protocol ForgotPasswordScreenViewModelDelegate {
    func validatingEmail(mail: String)
    var validation : ReactiveListener<GeneralResult> { get set }
    var mailSentStatus : ReactiveListener<ForgotPassResult> { get set }
    func webService(mail: String)
}

class ForgotPasswordScreenViewModel : ForgotPasswordScreenViewModelDelegate {
    var mailSentStatus: ReactiveListener<ForgotPassResult> = ReactiveListener(.none)
    
    var validation: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    
    func validatingEmail(mail: String) {
        if mail.isEmpty {
            validation.value = .failure(message: Alert.emptyFieldSub.rawValue)
        }
        else if isValidEmail(email: mail) == false {
            validation.value = .failure(message: Alert.emailSub.rawValue)
        }
        else {
            validation.value = .success
        }
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    func webService(mail: String) {
        UserService.forgotPass(mail: mail ) { (response) in
            switch response {
            case .success(let value):
                print(value)
                self.mailSentStatus.value = .success(message: value.message ?? "")
            case .failure(let error):
                self.mailSentStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}
