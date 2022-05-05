//
//  AddAddressViewModel.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation
import UIKit

protocol AddAddressViewModelDelegate {
    var city: String { get set }
    var cityMain: String { get set }
    var state: String { get set }
    var zip: String { get set }
    var country: String { get set }
    var address: String { get set }
    func validateTextFields()
    var validation: ReactiveListener<GeneralResult> { get set }
    func fullAddress()
}

class AddAddressViewModel : AddAddressViewModelDelegate {
    //Defining variables to store textfield data in
    var city: String = ""
    var cityMain: String = ""
    var state: String = ""
    var zip: String = ""
    var country: String = ""
    var address: String = ""
    
    var validation: ReactiveListener<GeneralResult> = ReactiveListener(.none)
    //MARK:- Validation of textfields
    func validateTextFields() {
        //MARK:- Displaying alert when textfields empty
        if city.isEmpty || cityMain.isEmpty || state.isEmpty || zip.isEmpty || country.isEmpty || address.isEmpty {
            validation.value = .failure(message: Alert.emptyFieldSub.rawValue)
        }
        else {
            validation.value = .success
        }
    }
    
    //MARK:- Getting full address
    func fullAddress() {
        let fullAddress: String = "\(address.capitalized) \(cityMain.capitalized),\(city.capitalized):- \(zip), \(state.capitalized), \(country.uppercased()) "
        UserDefaults.standard.addNewAddress(address: fullAddress)
    }
    
    //MARK:- Getting textfields data and storing it
    func storeData(text: String?, tag: Int) {
        switch tag {
        case 1:
            address = text ?? ""
        case 2:
            cityMain = text ?? ""
        case 3:
            city = text ?? ""
        case 4:
            state = text ?? ""
        case 5:
            zip = text ?? ""
        case 6:
            country = text ?? ""
        default:
            break
        }
    }
}
