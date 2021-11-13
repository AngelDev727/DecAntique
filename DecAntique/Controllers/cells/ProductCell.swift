//
//  ProductCell.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 04/04/1443 AH..
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    var entity: ProductModel! {
        didSet {
            lblProductName.text = "\(entity.product_name)"
            lblPrice.text = "\(entity.price)"
            if let img = entity.photo {
                imgPhoto.image = UIImage(data: img)
            } else {
                imgPhoto.image = UIImage(named: "Type2Red")
            }
            
        }
    }

}
