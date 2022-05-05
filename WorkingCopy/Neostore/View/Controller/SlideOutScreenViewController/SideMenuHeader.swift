//
//  SideMenuHeader.swift
//  Neostore
//
//  Created by Neosoft on 06/04/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import UIKit

class SideMenuHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var profileImg: LazyImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.layer.cornerRadius = profileImg.frame.width/2
        profileImg.layer.borderWidth = 5
        profileImg.layer.borderColor = UIColor.white.cgColor
    }
}
