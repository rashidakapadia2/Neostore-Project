//
//  User.swift
//  Neostore
//
//  Created by Neosoft on 09/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

struct User: Codable {
    var status: Int?
    var data: UserDetail?
    var message: String?
    var user_msg: String?
    
    enum codingKeys: String,CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
        case user_msg = "user_msg"
    }
}

struct UserDetail: Codable {
    var id: Int?
    var role_id: Int?
    var first_name: String?
    var last_name: String?
    var email: String?
    var username: String?
    var gender: String?
    var phone_no: String?
    var is_active: Bool?
    var created: String?
    var modified: String?
    var access_token: String?
    
    var dob: String?
    var profile_pic: String?
    
    enum codingKeys: String,CodingKey {
        case id = "id"
        case role_id = "role_id"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
        case username = "username"
        case gender = "gender"
        case phone_no = "phone_no"
        case is_active = "is_active"
        case created = "created"
        case modified = "modified"
        case access_token = "access_token"
        case dob = "dob"
        case profile_pic = "profile_pic"
    }
}

struct FetchUser: Codable {
    var status: Int?
    var data: FetchDetails?
    var message: String?
    var user_msg: String?
    
    enum codingKeys: String,CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
        case user_msg = "user_msg"
    }
}

struct FetchDetails: Codable {
    var user_data: UserDetail?
    var product_categories: [ProductCategory]?
    var total_carts: Int?
    var total_orders: Int?
    
    enum codingKeys: String,CodingKey {
        case user_data = "user_data"
        case product_categories = "product_categories"
        case total_carts = "total_carts"
        case total_orders = "total_orders"
    }
}

struct ProductCategory: Codable {
    var id: Int?
    var name: String?
    var icon_image: String?
    var created: String?
    var modified: String?
    
    enum codingKeys: String,CodingKey {
        case id = "id"
        case name = "name"
        case icon_image = "icon_image"
        case created = "created"
        case modified = "modified"
    }
}

struct ForgotPassReturn: Codable {
    var status: Int?
    var message, usermsg: String?
    
    enum codingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case usermsg = "user_msg"
    }
}

struct Update: Codable {
    var data: Name?
    var status: Int?
    var message: String?
    var user_msg: String?
    
    enum codingKeys: String,CodingKey {
        case data = "data"
        case status = "status"
        case message = "message"
        case user_msg = "user_msg"
    }
}
struct Name: Codable {
    var first_name: String?
    var last_name: String?
   
    enum codingKeys: String,CodingKey {
        case first_name = "first_name"
        case last_name = "last_name"
    }
}

// Temp Data
struct AuthResponse: Codable {
    let status: Int?
    let data: UserData?
    let message, userMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case status, data, message
        case userMsg = "user_msg"
    }
}

// MARK: - DataClass
struct UserData: Codable {
    let id, roleID: Int?
    let firstName, lastName, email, username: String?
    let profilePic, countryID, gender: String?
    let phoneNo: String?
    let dob: String?
    let isActive: Bool?
    let created, modified: String?
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case roleID = "role_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email, username
        case profilePic = "profile_pic"
        case countryID = "country_id"
        case gender
        case phoneNo = "phone_no"
        case dob
        case isActive = "is_active"
        case created, modified
        case accessToken = "access_token"
    }
}
