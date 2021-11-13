//
//  UserCell.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 04/04/1443 AH.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    var entity: UserModel! {
        didSet {
            lblName.text = "\(entity.username!)"
            lblEmail.text = "\(entity.email!)"
        }
    }

}
