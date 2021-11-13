//
//  SingleProductVC.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 07/04/1443 AH.
//

import UIKit

class SingleProductVC: BaseVC {

    var product: ProductModel?
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var txvDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = product {
            self.title = "Product Detail"
            imgPhoto.image = UIImage(data: data.photo!)
            lblName.text = data.product_name
            lblPrice.text = "\(data.price)"
            txvDescription.text = data.description
        } else {
            doDismiss()
        }
        
        
    }


}
