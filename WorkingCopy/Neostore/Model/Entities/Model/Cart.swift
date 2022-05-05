//
//  Cart.swift
//  Neostore
//
//  Created by Neosoft on 25/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

struct Cart: Codable {
    var status: Int?
    var data: Bool?
    var total_carts: Int?
    var message: String?
    var user_msg: String?
    
    enum codingKeys: String,CodingKey {
        case status = "status"
        case data = "data"
        case total_carts = "total_carts"
        case message = "message"
        case user_msg = "user_msg"
    }
}

//    struct EditCart: Codable {
//        var status: Int?
//        var data: Bool?
//        var message: String?
//        var user_msg: String?
//
//        enum codingKeys: String,CodingKey {
//            case status = "status"
//            case data = "data"
//            case message = "message"
//            case user_msg = "user_msg"
//        }
//    }

struct CartListItem: Codable {
    var status: Int?
    var data: [CartList]?
    var count: Int?
    var total: Int?
    
    enum codingKeys: String,CodingKey {
        case status = "status"
        case data = "data"
        case count = "count"
        case total = "total"
    }
}
struct CartList: Codable {
    var id: Int?
    var product_id: Int?
    var quantity: Int?
    var product: Cartlist?
    
    
    enum codingKeys: String,CodingKey {
        case id = "id"
        case product_id = "product_id"
        case quantity = "quantity"
        case product = "product"
        
    }
}
struct Cartlist: Codable {
    var id: Int?
    var name: String?
    var product_category: String?
    var cost: Int?
    var product_images: String?
    var sub_total: Int?
    
    enum codingKeys: String,CodingKey {
        case id = "id"
        case name = "name"
        case product_category = "product_category"
        case cost = "cost"
        case product_images = "product_images"
        case sub_total = "sub_total"
    }
}
