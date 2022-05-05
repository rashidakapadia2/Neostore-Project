//
//  StoreLocatorTableViewCell.swift
//  Neostore
//
//  Created by Neosoft on 11/03/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class StoreLocatorTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var lblAddressSubtitle: UILabel!
    
    public func configureStoreLocator(title: String, subtitle: String) {
        lblAddressTitle.text = title
        lblAddressSubtitle.text = subtitle
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
