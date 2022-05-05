//
//  AddressListCell.swift
//  Neostore
//
//  Created by Neosoft on 14/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class AddressListCell: UITableViewCell {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblNameSurname: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnSelectAddress: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configureAddressList(name: String, addressDesc: String) {
        lblNameSurname.text = name
        lblAddress.text = addressDesc
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
    }
    @IBAction func selectAddressTapped(_ sender: Any) {
        
    }
}
