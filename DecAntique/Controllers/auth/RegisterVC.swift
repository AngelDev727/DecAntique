//
//  RegisterVC.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 04/04/1443 AH.
//

import UIKit

class RegisterVC: BaseVC {
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfCPassword: UITextField!
    @IBOutlet weak var butManager: UIButton!
    @IBOutlet weak var butCustomer: UIButton!
    
    var userType = "customer"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        butCustomer.isSelected = true
    }
    
    func isValidCheck() -> Bool {
        if tfUsername.text!.isEmpty {
            showAlert("Please input user name.")
            return false
        } else if tfEmail.text!.isEmpty {
            showAlert("Please input your email.")
            return false
        } else if !isValidEmail(email: tfEmail.text!) {
            showAlert("Please input valid email.")
            return false
        } else if tfPassword.text!.isEmpty {
            showAlert("Please input password.")
            return false
        } else if tfCPassword.text != tfPassword.text {
            showAlert("Please confirm password.")
            return false
        }
        
        return true
    }
    
    @IBAction func didTapCustomer(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        butManager.isSelected = !butManager.isSelected
        
        userType = sender.isSelected ? "customer" : "manager"
    }
    
    @IBAction func didTapManager(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        butCustomer.isSelected = !butCustomer.isSelected
        userType = sender.isSelected ? "manager" : "customer"
    }
    
    @IBAction func didTapSignup(_ sender: Any) {
        if !isValidCheck() {
            return
        }
        showLoadingView(vc: self)
        let name = tfUsername.text!
        let email = tfEmail.text!
        let password = tfPassword.text!
        
        let res = DataBaseHelper.shared.saveUser(email: email, name: name, password: password, type: userType)
        hideLoadingView()
        
        if res.hasPrefix("success") {
            
            doDismiss(true)
            
            /*
            let id = res.components(separatedBy: " ")[1]
            userDefaluts.set(Int32(id), forKey: "user_id")
            userDefaluts.set(name, forKey: "user_name")
            userDefaluts.set(email, forKey: "user_email")
            userDefaluts.set(userType, forKey: "user_type")
            userDefaluts.set(password, forKey: "user_pwd")
            
            gotoVC("TabbarVC", true)
             */
        } else {
            showAlert(res)
        }
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        doDismiss(true)
    }
}
