//
//  OrderService.swift
//  Neostore
//
//  Created by Neosoft on 25/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

class OrderService {
    
    static func setOrder(address: String, completion: @escaping(APIResponse<Order>) -> Void){
        let params = ["address": address]
        APIManager.sharedInstance.performRequest(serviceType: .setOrder(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(Order.self, from: content)
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
    static func getOrderLists(completion: @escaping(APIResponse<OrderList>) -> Void){
        APIManager.sharedInstance.performRequest(serviceType: .getOrderList){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(OrderList.self, from: content)
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
    static func getOrderDetail(order_id: String, completion: @escaping(APIResponse<OrderResponse>) -> Void){
        let params = ["order_id": order_id]
        APIManager.sharedInstance.performRequest(serviceType: .getOrderDetail(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(OrderResponse.self, from: content)
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
