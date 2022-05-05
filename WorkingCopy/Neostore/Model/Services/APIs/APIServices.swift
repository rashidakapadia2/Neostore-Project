//
//  APIServices.swift
//  Neostore
//
//  Created by Neosoft on 03/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

typealias AnyDict = [String: Any]
typealias AnyDictString = [String: String]

let DEV_ROOT_POINT = "http://staging.php-dev.in:8844/trainingapp"
let PROD_ROOT_POINT = ""

let contentValue = "application/x-www-form-urlencoded"
let contentKey = "Content-Type"

enum NetworkEnvironment: String {
    case development
    case production
}

var networkEnvironment: NetworkEnvironment {
    return .development
}

var BaseURL: String {
    switch networkEnvironment {
    case .development :
        return DEV_ROOT_POINT
    case .production :
        return PROD_ROOT_POINT
    }
}


enum APIServices {
    case userRegister(parameters: AnyDict)
    case userLogin(parameters: AnyDict)
    case forgotPassword(parameters: AnyDict)
    case changePassword(parameters: AnyDict)
    case updateAccount(parameters: AnyDict)
    case fetchAccountDetails
    case getProductList(parameters: AnyDict)
    case getProductDetails(parameters: AnyDict)
    case setRating(parameters: AnyDict)
    case addToCart(parameters: AnyDict)
    case editCart(parameters: AnyDict)
    case deleteCart(parameters: AnyDict)
    case getCartItems
    case setOrder(parameters: AnyDict)
    case getOrderList
    case getOrderDetail(parameters: AnyDict)
}

extension APIServices {
    var Path: String {
        let apiDomain = "/api/"
        var servicePath: String = ""
        switch self {
        case .userRegister: servicePath = apiDomain + "users/register"
        case .userLogin: servicePath = apiDomain + "users/login"
        case .forgotPassword: servicePath = apiDomain + "users/forgot"
        case .changePassword: servicePath = apiDomain + "users/change"
        case .updateAccount: servicePath = apiDomain + "users/update"
        case .fetchAccountDetails: servicePath = apiDomain + "users/getUserData"
        case .getProductList: servicePath = apiDomain + "products/getList"
        case .getProductDetails: servicePath = apiDomain + "products/getDetail"
        case .setRating: servicePath = apiDomain + "products/setRating"
        case .addToCart: servicePath = apiDomain + "addToCart"
        case .editCart: servicePath = apiDomain + "editCart"
        case .deleteCart: servicePath = apiDomain + "deleteCart"
        case .getCartItems: servicePath = apiDomain + "cart"
        case .setOrder: servicePath = apiDomain + "order"
        case .getOrderList: servicePath = apiDomain + "orderList"
        case .getOrderDetail: servicePath = apiDomain + "orderDetail"
        }
        
        return BaseURL + servicePath
    }
    
    
    var parameters: AnyDict? {
        switch self {
        case .userRegister(parameters: let param), .userLogin(let param), .forgotPassword(let param), .changePassword(let param), .updateAccount(let param), .getProductList(let param), .getProductDetails(let param), .setRating(let param), .addToCart(let param), .editCart(let param), .deleteCart(let param), .setOrder(let param), .getOrderDetail(let param) :
            return param
        default:
            return nil
        }
    }
    
    //headers code
    var header: AnyDictString {
        var headerDict = AnyDictString()
        headerDict[contentKey] = contentValue
        
        switch self {
        case .changePassword(_), .updateAccount(_), .fetchAccountDetails, .addToCart(_), .editCart(_), .deleteCart(_), .getCartItems, .setOrder(_), .getOrderList, .getOrderDetail(_):
            let currentAccessToken = UserDefaults.standard.getUserToken() ?? "NO TOKEN"
            headerDict = [contentKey: contentValue,
                          "access_token": currentAccessToken]
        default:
            break
        }
        return headerDict
    }
    
    var httpMethod: String {
        switch self {
        case .fetchAccountDetails, .getProductList, .getProductDetails, .getCartItems, .getOrderList, .getOrderDetail :
            return "GET"
        default:
            return "POST"
        }
    }
}

