//
//  ProductData.swift
//  Neostore
//
//  Created by Neosoft on 09/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

//struct ProductData: Codable {
//    var status: Int?
//    var data: [ProductDatas]?
//
//    enum codingKeys: String,CodingKey {
//        case status = "status"
//        case data = "data"
//    }
//}
//
//struct ProductDatas: Codable {
//    var prod_id: Int?
//    var prod_categoryID: Int?
//    var name: String?
//    var producer: String?
//    var description: String?
//    var cost: Int?
//    var rating: Int?
//    var view_count: Int?
//    var prod_images: String?
//    var created: String?
//    var modified: String?
//
//    enum codingKeys: String,CodingKey {
//        case prod_id = "id"
//        case prod_categoryID = "product_category_id"
//        case name = "name"
//        case producer = "producer"
//        case description = "description"
//        case cost = "cost"
//        case rating = "rating"
//        case view_count = "view_count"
//        case prod_images = "prod_images"
//        case created = "created"
//        case modified = "modified"
//    }
//}

struct ProductData: Codable {
    let status: Int?
    let data: [ProductDatas]?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, data, message
        case userMsg = "user_msg"
    }
}

struct ProductDatas: Codable {
    let id, productCategoryID: Int?
    let name, producer, datumDescription: String?
    let rating, viewCount: Int?
    let created, modified: String?
    let productImages: String?
    let cost: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productCategoryID = "product_category_id"
        case name, producer
        case datumDescription = "description"
        case cost, rating
        case viewCount = "view_count"
        case created, modified
        case productImages = "product_images"
    }
}

//struct ProductDetails: Codable {
//    var status: Int?
//    var data: ProductDetail?
//    var message: String?
//    var user_message: String?
//
//    enum codingKeys: String,CodingKey {
//        case status = "status"
//        case data = "data"
//        case message = "message"
//        case user_message = "user_msg"
//    }
//}
//
//struct ProductDetail: Codable {
//    var prod_id: Int?
//    var prod_categoryID: Int?
//    var name: String?
//    var producer: String?
//    var description: String?
//    var cost: Int?
//    var rating: Int?
//    var view_count: Int?
//    var prod_images: ImageDetail?
//    var created: String?
//    var modified: String?
//
//    enum codingKeys: String,CodingKey {
//        case prod_id = "id"
//        case prod_categoryID = "product_category_id"
//        case name = "name"
//        case producer = "producer"
//        case description = "description"
//        case cost = "cost"
//        case rating = "rating"
//        case view_count = "view_count"
//        case prod_images = "prod_images"
//        case created = "created"
//        case modified = "modified"
//    }
//}
//
//struct ImageDetail: Codable {
//    var id: Int?
//    var product_id: Int?
//    var image: String?
//    var created: String?
//    var modified: String?
//
//    enum codingKeys: String,CodingKey {
//        case id = "id"
//        case product_id = "product_id"
//        case image = "image"
//        case created = "created"
//        case modified = "modified"
//    }
//}


struct ProductDetails: Codable {
    let status: Int?
    let data: ProductDetail?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, data, message
        case userMsg = "user_msg"
    }
}

// MARK: - DataClass
struct ProductDetail: Codable {
    let id, productCategoryID: Int?
    let name, producer, dataDescription: String?
    let cost, rating, viewCount: Int?
    let created, modified: String?
    let productImages: [ProductImage]?

    enum CodingKeys: String, CodingKey {
        case id
        case productCategoryID = "product_category_id"
        case name, producer
        case dataDescription = "description"
        case cost, rating
        case viewCount = "view_count"
        case created, modified
        case productImages = "product_images"
    }
}

// MARK: - ProductImage
struct ProductImage: Codable {
    let id, productID: Int?
    let image: String?
    let created, modified: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case image, created, modified
    }
}

struct SetProductRatingResponse: Codable {
    let status: Int?
    let data: SetProductDetail?
    let message, userMsg: String?

    enum CodingKeys: String, CodingKey {
        case status, data, message
        case userMsg = "user_msg"
    }
}

// MARK: - DataClass
struct SetProductDetail: Codable {
    let id, productCategoryID: Int?
    let name, producer, dataDescription: String?
    let cost, viewCount: Int?
    let rating: Double?
    let created, modified: String?
    let productImages: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productCategoryID = "product_category_id"
        case name, producer
        case dataDescription = "description"
        case cost, rating
        case viewCount = "view_count"
        case created, modified
        case productImages = "product_images"
    }
}
