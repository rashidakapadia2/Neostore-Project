//
//  Order.swift
//  Neostore
//
//  Created by Neosoft on 25/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

struct Order: Codable {
    var status: Int?
    var message: String?
    var user_msg: String?
    
    enum codingKeys: String,CodingKey {
        case status = "status"
        case message = "message"
        case user_msg = "user_msg"
    }
}
//// MARK: - Welcome
//struct OrderDetail: Codable {
//    let status: Int?
//    let data: [Orderdetail]?
//}
//
//// MARK: - DataClass
//struct Orderdetail: Codable {
//    let id, cost: Int?
//    let address: String?
//    let orderDetails: [Orderdetails]?
//
//    enum CodingKeys: String, CodingKey {
//        case id, cost, address
//        case orderDetails = "order_details"
//    }
//}
//
//// MARK: - OrderDetail
//struct Orderdetails: Codable {
//    let id, orderID, productID, quantity: Int?
//    let total: Int?
//    let prodName, prodCatName: String?
//    let prodImage: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case orderID = "order_id"
//        case productID = "product_id"
//        case quantity, total
//        case prodName = "prod_name"
//        case prodCatName = "prod_cat_name"
//        case prodImage = "prod_image"
//    }
//}
struct OrderResponse: Codable {
    let status: Int
    let message: String?
    let data: OrderMainModel
    let userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, message, data
        case userMsg = "user_msg"
    }
}

// MARK: - OrderMainModel
struct OrderMainModel: Codable {
    let id, cost: Int
    let address: String
    let orderDetails: [ResponseOrder]

    enum CodingKeys: String, CodingKey {
        case id, cost, address
        case orderDetails = "order_details"
    }
}

// MARK: - OrderDetail
struct ResponseOrder: Codable {
    let id, orderID, productID, quantity: Int
    let total: Int
    let prodName, prodCatName: String
    let prodImage: String

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case productID = "product_id"
        case quantity, total
        case prodName = "prod_name"
        case prodCatName = "prod_cat_name"
        case prodImage = "prod_image"
    }
}

//struct OrderDetail: Codable {
//    var status: Int?
//    var data: [Orderdetail]?
//    var message: String?
//    var user_msg: String?
//
//    enum codingKeys: String,CodingKey {
//        case status = "status"
//        case data = "data"
//        case message = "message"
//        case user_msg = "user_msg"
//    }
//}
//
//struct Orderdetail: Codable {
//    var id: Int?
//    var cost: Int?
//    var created: String?
//    var order_details: [Orderdetails]?
//
//    enum codingKeys: String,CodingKey {
//        case id = "id"
//        case cost = "cost"
//        case created = "created"
//        case order_details = "order_details"
//    }
//}
//struct Orderdetails: Codable {
//    var id: Int?
//    var product_id: Int?
//    var quantity: Int?
//    var total: Int?
//    var prod_name: String?
//    var prod_cat_name: String?
//    var prod_image: String?
//
//    enum codingKeys: String,CodingKey {
//        case id = "id"
//        case product_id = "product_id"
//        case quantity = "quantity"
//        case total = "total"
//        case prod_name = "prod_name"
//        case prod_cat_name = "prod_cat_name"
//        case prod_image = "prod_image"
//    }
//}

struct OrderList: Codable {
    var status: Int?
    var data: [Orderlist]?
    var message: String?
    var user_msg: String?
    
    enum codingKeys: String,CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
        case user_msg = "user_msg"
    }
}

struct Orderlist: Codable {
    var id: Int?
    var cost: Int?
    var created: String?
    
    enum codingKeys: String,CodingKey {
        case id = "id"
        case cost = "cost"
        case created = "created"
    }
}

