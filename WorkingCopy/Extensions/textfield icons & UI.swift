//
//  textfield icons & UI.swift
//  Neostore
//
//  Created by Neosoft on 08/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation
import UIKit

func setUpTextfield(textfield: UITextField, image: UIImage?) {
    textfield.textfieldAttributes()
    if let img = image {
        textfield.leftImgDisplay(image: img)
    }
}

extension UITextField {
    func textfieldAttributes() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    func leftImgDisplay(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 24, height: 30))
        imageView.image = image
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        containerView.addSubview(imageView)
        
        leftView = containerView
        leftViewMode = .always
    }
}
