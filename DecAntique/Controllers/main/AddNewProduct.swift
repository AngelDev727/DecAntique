//
//  AddNewProduct.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 04/04/1443 AH.
//

import UIKit

class AddNewProduct: BaseVC, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var viwPhoto: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var butAddPhoto: UIButton!
    
    var selctedPhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viwPhoto.layer.borderWidth = 1
        viwPhoto.layer.borderColor = UIColor.systemGray5.cgColor
        viwPhoto.layer.cornerRadius = 5
        
        
        butAddPhoto.layer.borderWidth = 1
        butAddPhoto.layer.borderColor = UIColor.systemBlue.cgColor
        butAddPhoto.layer.cornerRadius = 15
        
        tvDescription.layer.borderWidth = 1
        tvDescription.layer.borderColor = UIColor.systemGray5.cgColor
        tvDescription.layer.cornerRadius = 5
        
    }
    
    @IBAction func didTapAddPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        imgPhoto.image = userPickedImage
        picker.dismiss(animated: true)
        selctedPhoto = true
    }
    
    @IBAction func didTapAddProduct(_ sender: Any) {
        if !selctedPhoto {
            showAlert("Please select photo.")
        } else if tfName.text!.isEmpty {
            showAlert("Please input product name.")
        } else if tfPrice.text!.isEmpty {
            showAlert("Please input product price.")
        } else if tvDescription.text!.isEmpty {
            showAlert("Please input description.")
        } else {
            let model = ProductModel(id: 0, product_name: tfName.text!, price: Double(tfPrice.text!) ?? 0, description: tvDescription.text!, flag: false, photo: imgPhoto.image?.pngData())
            let res = DataBaseHelper.shared.saveProduct(data: model)
            
            if res == "success" {
                showAlert("Your profile was updated successfuly.")
                doDismiss(true)
            } else {
                showAlert(res)
            }
        }
        
    }
    
}
