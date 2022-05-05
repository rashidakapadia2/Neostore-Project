//
//  Constants.swift
//  Neostore
//
//  Created by Neosoft on 04/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation
import UIKit
//MARK:- Response using generics
enum APIResponse<T> {
    case success(value: T)
    case failure(error: Error)
}
//MARK:- Textfield icons
enum Image: String {
    case user = "username_icon"
    case mail = "email_icon"
    case lock = "password_icon"
    case unlock = "cpassword_icon"
    case phone = "cellphone_icon"
    case birthday = "dob_icon"
}
//MARK:-General Icons
enum Icons: String {
    case menu = "menu_icon"
    case search = "search_icon"
    case add = "pluss"
    case starFull = "star_check"
    case starEmpty = "star_unchek"
}
//MARK:- Side Menu names list
enum SideMenuName: Int {
    case MyCart
    case Tables
    case Sofas
    case Chairs
    case Cupboards
    case MyAccount
    case StoreLocator
    case MyOrders
    case Logout
}
//MARK:- Side Menu Icons List
enum SideMenuIcon: Int {
    case shoppingcart_icon
    case table
    case sofa_icon
    case chair
    case cupboard
    case username_icon
    case storelocator_icon
    case myorders_icon
    case logout_icon
}
//MARK:- Display custom alerts for textfield validation
enum Alert: String {
    case emptyFieldSub = "No Field should be empty"
    case firstnameSub = "First Name should be 3 or more characters"
    case lastnameSub = "Last Name should be 3 or more characters"
    case emailSub = "Email should be in correct format.Please include @ then domain name followed by .com"
    case passwordSub = "Please include atleast one capital letter, special character, number, small case letter in password"
    case confpassSub = "Password and Conform Password should match"
    case numSub = "Number cannot include letters or special characters"
    case phoneSub = "Please enter 10 digits in number field"
    case checkFieldSub = "Please check the checkbox"
}
//MARK:- Display general custom alerts
enum GeneralAlert: String {
    case emailSent = "Password has been sent to the coresponding email successfully"
    case registrationSuccess = "Registration has been done successfully"
    case editProfileSuccess = "User details have been edited successfully"
    case ratingZero = "Please rate the product out of 5 stars"
    case emptyQnty = "Please enter quantity of product you wish to buy"
    case notValidQnty = "Please enter valid quantity. Quantity should be between 1 to 7"
}
