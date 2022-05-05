//
//  UserService.swift
//  Neostore
//
//  Created by Neosoft on 10/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

func jSONDecoding<T: Decodable>(jSON: Data) -> APIResponse<T>{
    do {
        let jsonDecoder = JSONDecoder()
        let responseData = try jsonDecoder.decode(T.self, from: jSON)
        return .success(value: responseData)
    } catch let error {
        debugPrint(error.localizedDescription)
        return .failure(error: error)
    }
}

class UserService{
    
    static func userLogIn(username: String, password: String, completion: @escaping(APIResponse<AuthResponse>) -> Void){
        let params = ["email": username, "password": password]
        APIManager.sharedInstance.performRequest(serviceType: .userLogin(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(AuthResponse.self, from: content)
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
    static func forgotPass(mail: String, completion: @escaping(APIResponse<ForgotPassReturn>) -> Void){
        let params = ["email": mail]
        APIManager.sharedInstance.performRequest(serviceType: .forgotPassword(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(ForgotPassReturn.self, from: content)
                        //                        let tempData = try JSONSerialization.jsonObject(with: content) as! [String: Any]
                        //                        print(tempData)
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
    static func registerUser(fn: String, ln: String, em: String, pw: String, cp: String, gen: String, num: String, completion: @escaping(APIResponse<User>) -> Void){
        let params = ["first_name": fn, "last_name": ln, "email": em, "password": pw, "confirm_password": cp,"gender": gen, "phone_no": num]
        APIManager.sharedInstance.performRequest(serviceType: .userRegister(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(User.self, from: content)
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
    
    static func fetchUser(completion: @escaping(APIResponse<FetchUser>) -> Void){
        APIManager.sharedInstance.performRequest(serviceType: .fetchAccountDetails){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(FetchUser.self, from: content)
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
    static func updateUserDetails(fn: String, ln: String, em: String, dob: String, num: String, completion: @escaping(APIResponse<Update>) -> Void){
        let params = ["first_name": fn, "last_name": ln, "email": em, "dob": dob, "phone_no": num, "profile_pic": "null"]
        APIManager.sharedInstance.performRequest(serviceType: .updateAccount(parameters: params)){
            (response) in
            switch response {
            case .success(let value):
                if let content = value as? Data {
                    do {
                        let responseData = try JSONDecoder().decode(Update.self, from: content)
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
    static func changePassword(old: String, password: String, conf: String, completion: @escaping(APIResponse<Order>) -> Void){
        let params = ["old_password": old, "password": password, "confirm_password": conf]
        APIManager.sharedInstance.performRequest(serviceType: .changePassword(parameters: params)){
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
}
