//
//  Response.swift
//  Neostore
//
//  Created by Neosoft on 10/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    //MARK:- To show alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    //MARK:- Displaying Loader View
    func showLoader(view: UIView, aicView: inout UIView?) {
        let parentView = UIView(frame: UIScreen.main.bounds)
        parentView.isUserInteractionEnabled = false
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.3)
        containerView.layer.cornerRadius = 10
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        parentView.addSubview(containerView)
        containerView.center = parentView.center
        
        let aic = UIActivityIndicatorView()
        aic.color = .white
        aic.startAnimating()
        aic.center = parentView.center
        
        parentView.addSubview(aic)
        view.addSubview(parentView)
        
        // Assign view
        aicView = parentView
    }
    //MARK:- Hiding loader view
    func hideLoader(viewLoaderScreen: UIView?) {
        viewLoaderScreen?.isHidden = true
    }
}
//MARK:- Custom button defining
class CustomButton : UIButton
{
    @IBInspectable var cornerRadius : CGFloat = 0.0
    {
        didSet{
            layer.cornerRadius = 14
        }
    }
}
//MARK:- Saving and retrieving data from USERDEFAULTS
extension UserDefaults{
    
    //MARK:- Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    // MARK:- Retrieve Login Status
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    //MARK:- Save User Data
    func setUserToken(value: String? ){
        set(value, forKey: UserDefaultKeys.userToken.rawValue)
    }
    
    //MARK:- Retrieve User Data
    func getUserToken() -> String? {
        return string(forKey: UserDefaultKeys.userToken.rawValue)
    }
    
    // MARK:- Add New Address
    func addNewAddress(address: String) {
        var allAddress = UserDefaults.standard.stringArray(forKey: UserDefaultKeys.address.rawValue) ?? [String]()
        allAddress.append(address)
        UserDefaults.standard.set(allAddress, forKey: UserDefaultKeys.address.rawValue)
    }
    
    // MARK:- Get All Address
    func getAllAddress() -> [String] {
        let allAddress = UserDefaults.standard.stringArray(forKey: UserDefaultKeys.address.rawValue) ?? [String]()
        return allAddress
    }
}
