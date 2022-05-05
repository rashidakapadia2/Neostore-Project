//
//  MyCartCell.swift
//  Neostore
//
//  Created by Neosoft on 18/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

protocol editQntyDelegate {
    func PickAQuantity(num: Int)
}

class MyCartCell: UITableViewCell {

    @IBOutlet weak var imgDownArrow: UIImageView!
    @IBOutlet weak var txtQnty: UITextField!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgView: LazyImageView!
    
    var selectionDelegate: editQntyDelegate?
    var id = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ImgTap()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    public func configureCartList(name: String, desc: String, price: Int, qnty: Int, img: String) {
        lblDesc.text = name
        lblType.text = desc
        lblPrice.text = "\(price)"
        txtQnty.text = "\(qnty)"
        let url = URL(string: img)
        if let actualUrl = url {
            imgView.loadImage(fromURL: actualUrl, placeHolderImage: "placeholder")
        }
    }
    func ImgTap() {
        let imgTapped = UITapGestureRecognizer(target: self, action: #selector(img(_:)))
        imgDownArrow.isUserInteractionEnabled = true
        imgDownArrow.addGestureRecognizer(imgTapped)
    }
    @objc func img(_ sender: UITapGestureRecognizer) {
        selectionDelegate?.PickAQuantity(num: id)
    }
}
