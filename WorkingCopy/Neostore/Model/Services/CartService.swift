//
//  CartService.swift
//  Neostore
//
//  Created by Neosoft on 25/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

class CartService {
    
    static func addToCart(product_id: Int, quantity: Int, completion: @escaping(APIResponse<Cart>) -> Void){
        let params = ["product_id": product_id, "quantity": quantity]
        APIManager.sharedInstance.performRequest(serviceType: .addToCart(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(Cart.self, from: content)
                        completion(.success(value: responseData))
                    } catch {
                        print(error)
                    }
                }
                else{
                    print("\(String(describing: CustomErrors.noData.errorDescription))")
                }
            case .failure(let error):
                print("In Failure")
                debugPrint(error.localizedDescription)
                print("Wrong pass")
                completion(.failure(error: error))
            }
        }
    }
    
    static func editCart(product_id: Int, quantity: Int, completion: @escaping(APIResponse<Cart>) -> Void){
        let params = ["product_id": product_id, "quantity": quantity]
        APIManager.sharedInstance.performRequest(serviceType: .editCart(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(Cart.self, from: content)
                        completion(.success(value: responseData))
                    } catch {
                        print(error)
                    }
                }
                else{
                    print("\(String(describing: CustomErrors.noData.errorDescription))")
                }
            case .failure(let error):
                print("In Failure")
                debugPrint(error.localizedDescription)
                print("Wrong pass")
                completion(.failure(error: error))
            }
        }
    }
    static func deleteCart(product_id: Int, completion: @escaping(APIResponse<Cart>) -> Void){
        let params = ["product_id": product_id]
        APIManager.sharedInstance.performRequest(serviceType: .deleteCart(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(Cart.self, from: content)
                        completion(.success(value: responseData))
                    } catch {
                        print(error)
                    }
                }
                else{
                    print("\(String(describing: CustomErrors.noData.errorDescription))")
                }
            case .failure(let error):
                print("In Failure")
                debugPrint(error.localizedDescription)
                print("Wrong pass")
                completion(.failure(error: error))
            }
        }
    }
    static func listCartItems(completion: @escaping(APIResponse<CartListItem>) -> Void){
        APIManager.sharedInstance.performRequest(serviceType: .getCartItems){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(CartListItem.self, from: content)
                        completion(.success(value: responseData))
                    } catch {
                        print(error)
                    }
                }
                else{
                    print("\(String(describing: CustomErrors.noData.errorDescription))")
                }
            case .failure(let error):
                print("In Failure")
                debugPrint(error.localizedDescription)
                print("Wrong pass")
                completion(.failure(error: error))
            }
        }
    }
}
