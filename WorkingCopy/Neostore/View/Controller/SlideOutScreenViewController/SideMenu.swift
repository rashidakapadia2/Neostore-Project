//
//  SideMenu.swift
//  Neostore
//
//  Created by Neosoft on 06/04/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class SideMenu: UITableViewCell {
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBadge: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
