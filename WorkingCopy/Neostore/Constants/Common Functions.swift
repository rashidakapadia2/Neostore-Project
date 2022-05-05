//
//  common functions.swift
//  Neostore
//
//  Created by Neosoft on 17/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Validation functions
func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

func isValidPassword(password: String) -> Bool {
    let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{4,64}$"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordTest.evaluate(with: password)
}

func isValidNumber(number: String) -> Bool {
    let numberRegEx = "^([0-9]*)$"
    let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
    return numberTest.evaluate(with: number)
}
func isValidQnty(number: String) -> Bool {
    let numberRegEx = "\\A[1-7]{1}\\z"
    let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
    return numberTest.evaluate(with: number)
}

//MARK:- image to string
func convertImageToBase64String (img: UIImage) -> String {
    guard let imageData = img.pngData() else { return "" }
    return imageData.base64EncodedString(options: .lineLength64Characters)
}
//MARK:- string to image
func convertBase64StringToImage (imageBase64String: String) -> UIImage {
    let imageData = Data(base64Encoded: imageBase64String)
    let image = UIImage(data: imageData!)
    return image!
}
