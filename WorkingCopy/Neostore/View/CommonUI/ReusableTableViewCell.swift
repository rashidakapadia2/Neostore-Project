//
//  ReusableTableViewCell.swift
//  Neostore
//
//  Created by Neosoft on 14/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class ReusableTableViewCell: UITableViewCell {
    @IBOutlet weak var lblQnty: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgView: LazyImageView!
    
    public func configureList(name: String, desc: String, price: Int, qnty: Int, img: String) {
        lblDesc.text = name
        lblType.text = desc
        lblPrice.text = "\(price)"
        lblQnty.text = "\(qnty)"
        let url = URL(string: img)
        if let actualUrl = url {
            imgView.loadImage(fromURL: actualUrl, placeHolderImage: "placeholder")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
