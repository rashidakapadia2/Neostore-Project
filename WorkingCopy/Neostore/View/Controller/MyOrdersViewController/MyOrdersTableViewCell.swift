//
//  MyOrdersTableViewCell.swift
//  Neostore
//
//  Created by Neosoft on 17/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class MyOrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    public func configureOrderList(orderID: Int, desc: String, price: Int) {
        lblOrderID.text = "\(orderID)"
        lblOrderDate.text = desc
        lblPrice.text = "\(price)"
    }
    
    var line = UIBezierPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        makeLine()
    }
    
    //MARK:- Drawing a line
    func makeLine() {
        line.move(to: .init(x: 30, y: bounds.height / 2 ))
        line.addLine(to: .init(x: bounds.width, y: bounds.height / 2))
        UIColor.red.setStroke()
        line.lineWidth = 2
    }
}
