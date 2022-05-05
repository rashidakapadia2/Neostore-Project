//
//  ProductService.swift
//  Neostore
//
//  Created by Neosoft on 25/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

class ProductService {
    
    static func prodList(categoryID: String, completion: @escaping(APIResponse<ProductData>) -> Void){
        let params = ["product_category_id": categoryID]
        APIManager.sharedInstance.performRequest(serviceType: .getProductList(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(ProductData.self, from: content)
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
    static func prodDetail(prodID: String, completion: @escaping(APIResponse<ProductDetails>) -> Void){
        let params = ["product_id": prodID]
        APIManager.sharedInstance.performRequest(serviceType: .getProductDetails(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(ProductDetails.self, from: content)
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
    static func setRating(categoryID: String,rating: Int, completion: @escaping(APIResponse<SetProductRatingResponse>) -> Void){
        let params = ["product_id": categoryID, "rating": rating] as AnyDict
        APIManager.sharedInstance.performRequest(serviceType: .setRating(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(SetProductRatingResponse.self, from: content)
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
