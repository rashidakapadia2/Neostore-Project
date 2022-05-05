//
//  ReusableTableViewCell.swift
//  Neostore
//
//  Created by Neosoft on 07/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

public class ProductViewCell: UITableViewCell {
    @IBOutlet weak var imgProd_image: LazyImageView!
    @IBOutlet weak var lblProd_Name: UILabel!
    @IBOutlet weak var lblProd_Description: UILabel!
    @IBOutlet weak var lblProd_Price: UILabel!
    @IBOutlet var ratingStars: [UIImageView]!
    var rate: Int = 0
    let fullStar = UIImage.init(imageLiteralResourceName: Icons.starFull.rawValue)
    let emptyStar = UIImage.init(imageLiteralResourceName: Icons.starEmpty.rawValue)
    
    //MARK:- Configuring product
    public func configureProductsList(name: String, desc: String, price: Int, rating: Int, img: String) {
        lblProd_Name.text = name
        lblProd_Description.text = desc
        lblProd_Price.text = "Rs. \(price)"
        rate = rating
        displayRating(rate: rate)
        //MARK:- image display in cells of tableView
        let url = URL(string: img)
        if let actualUrl = url {
            imgProd_image.loadImage(fromURL: actualUrl, placeHolderImage: "placeholder")
        }
    }
    func displayRating(rate: Int) {
        for i in 1...5 {
            if i <= rate {
                ratingStars[i-1].image = UIImage(named: Icons.starFull.rawValue)
            }
            else {
                ratingStars[i-1].image = UIImage(named: Icons.starEmpty.rawValue)
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
