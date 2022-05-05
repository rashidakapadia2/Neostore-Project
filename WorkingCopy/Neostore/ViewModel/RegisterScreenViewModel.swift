//
//  RegisterScreenViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation
import UIKit

protocol RegisterScreenViewModelDelegate {
    var fn: String { get set }
    var ln: String { get set }
    var em: String { get set }
    var pw: String { get set }
    var cp: String { get set }
    var gen: String { get set }
    var num: String { get set }
    var check: Bool { get set }
    func validateTextFields()
    func webService()
    var validation: ReactiveListener<GeneralResult> { get set }
    var registrationStatus: ReactiveListener<GeneralResult> { get set }
}

class RegisterScreenViewModel : RegisterScreenViewModelDelegate {
    var fn: String = ""
    var ln: String = ""
    var em: String = ""
    var pw: String = ""
    var cp: String = ""
    var gen: String = "M"
    var num: String = ""
    var check: Bool = false
    
    var registrationStatus: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    var validation: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    //MARK:- Validating Textfield Input with relevant Constraints
    func validateTextFields() {
        
        
        if ((fn.isEmpty) || (ln.isEmpty) || (em.isEmpty) || (pw.isEmpty) || (cp.isEmpty) || (num.isEmpty)) {
            validation.value = .failure(message: Alert.emptyFieldSub.rawValue)
            
        }
        else if fn.count <= 2 {
          //  showAlert(title: "First Name should be 3 or more characters", message: "Please enter 3 or more characters in First Name textfield")
            validation.value = .failure(message: Alert.firstnameSub.rawValue)
        }
        else if ln.count <= 2 {
         //   showAlert(title: "Last Name should be 3 or more characters", message: "Please enter 3 or more characters in Last Name textfield")
            validation.value = .failure(message: Alert.lastnameSub.rawValue)
        }
        else if isValidEmail(email: em) == false {
         //   showAlert(title: "Email should be in correct format", message: "include @ then domain name followed by .com")
            validation.value = .failure(message: Alert.emailSub.rawValue)
            
        }
        else if isValidPassword(password: pw) == false {
         //   showAlert(title: "Password should be strong", message: "Please include atleast one capital letter, special character, number, small case letter")
            validation.value = .failure(message: Alert.passwordSub.rawValue)
        }
        else if pw != cp {
         //   showAlert(title: "Password and Conform Password do not match", message: "Please enter correct confirm password")
           validation.value = .failure(message: Alert.passwordSub.rawValue)
        }
        else if isValidNumber(number: num) == false {
          //  showAlert(title: "Number cannot include letters or special characters", message: "Please include only digits/numbers")
           validation.value = .failure(message: Alert.numSub.rawValue)
        }
        else if num.count != 10 {
          //  showAlert(title: "Phone Number should be valid", message: "Please enter 10 digits")
            validation.value = .failure(message: Alert.phoneSub.rawValue)
        }
//        else if !check {
//        //    showAlert(title: Alert.title.rawValue, message: Alert.subtitle.rawValue)
//           validation.value = .failure(message: Alert.checkFieldSub.rawValue)
//        }
        else{
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
            pw = text ?? ""
        case 5:
            cp = text ?? ""
        case 6:
            num = text ?? ""
        default:
            break
        }
    }
    //MARK:- Calling webservice for Register Screen
    func webService() {
        print("HERE")
        UserService.registerUser(fn: fn, ln: ln, em: em, pw: pw, cp: cp, gen: gen, num: num) { (response) in
            switch response {
            case .success(let value):
                print(value)
                self.registrationStatus.value = .success
            case .failure(let error):
                self.registrationStatus.value = .failure(message: error.localizedDescription)
            }
        }
    }
}


