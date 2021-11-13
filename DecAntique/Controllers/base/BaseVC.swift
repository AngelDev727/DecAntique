//
//  BaseVC.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 03/04/1443 AH.
//

import UIKit
import MBProgressHUD

class BaseVC: UIViewController {
    var hud: MBProgressHUD?
    var tap:UITapGestureRecognizer?
    let userDefaluts = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - progressHUD function
    func getProgressHUD(view : UIView, mode: MBProgressHUDMode = .annularDeterminate) -> MBProgressHUD {
    
        let hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud.mode = mode
        hud.label.text = "Loading";
        hud.animationType = .zoomIn
        hud.tintColor = UIColor.white
        hud.contentColor = UIColor.systemBlue
        hud.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return hud
    }
    
    func showLoadingView(view : UIView, label: String = "", mode: MBProgressHUDMode = .indeterminate) {
    
        hud = MBProgressHUD.showAdded(to:view, animated: true)
        hud!.mode = mode
        if label != "" {
            hud!.label.text = label;
        }
        hud!.animationType = .zoomIn
        hud!.tintColor = UIColor.white
        hud!.contentColor = UIColor.systemBlue
        hud!.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func showLoadingView(label: String = "") {

        let window = UIApplication.shared.key!.rootViewController

        if window != nil {
            hud = MBProgressHUD.showAdded(to: window!.view, animated: true)
        } else {
            hud = MBProgressHUD()
        }
        
        if label != "" {
            hud!.label.text = label;
        }
        
        hud!.mode = .indeterminate
        hud!.animationType = .zoomIn
        hud!.tintColor = UIColor.gray
        hud!.contentColor = UIColor.systemBlue
        hud!.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
    }
    
    func showLoadingView(vc: UIViewController, label: String = "") {
        
        hud = MBProgressHUD.showAdded(to: vc.view, animated: true)
        
        if label != "" {
            hud!.label.text = label;
        }
        hud!.mode = .indeterminate
        hud!.animationType = .zoomIn
        hud!.tintColor = UIColor.darkGray
        hud!.contentColor = UIColor.systemBlue
        hud!.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func hideLoadingView() {
       if let hud = hud {
           hud.hide(animated: true)
       }
    }
    
    // MARK: - goto new viewcontroller or dismiss
    func gotoNavVC (_ nameVC: String, _ animated: Bool = true) {
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: nameVC)
        self.navigationController?.pushViewController(toVC!, animated: animated)
    }
    
    func doDismiss(_ animated: Bool = true){
        self.navigationController?.popViewController(animated: animated)
    }
    
    func doRootDismiss(_ animated: Bool = true){
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    func gotoVC(_ nameVC: String, _ animated: Bool = false){
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: nameVC)
        toVC!.modalPresentationStyle = .fullScreen
        self.present(toVC!, animated: animated, completion: nil)
    }
    
    // MARK: - show alert
    func showAlertDialog(title: String!, message: String!, positive: String?, negative: String?) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if (positive != nil) {
            alert.addAction(UIAlertAction(title: positive, style: .default, handler: nil))
        }

        if (negative != nil) {
            alert.addAction(UIAlertAction(title: negative, style: .default, handler: nil))
        }

        DispatchQueue.main.async(execute:  {
         self.present(alert, animated: true, completion: nil)
        })
    }

    func showError(_ message: String!) {
        showAlertDialog(title: "", message: message, positive:"OK", negative: nil)
    }

    func showSuccess(_ message: String!) {
        showAlertDialog(title: "", message: message, positive: "OK", negative: nil)
    }
     
    internal func showAlert(title: String?, message: String?, positive: String, negative: String?, okClosure: (() -> Void)?, cancelClosure: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if negative != nil {
            let noAction = UIAlertAction(title: negative, style: .destructive, handler: { (action: UIAlertAction) in
                if cancelClosure != nil {
                    cancelClosure!()
                }
            })
            alertController.addAction(noAction)
        }
        
        let yesAction = UIAlertAction(title: positive, style: .default, handler: { (action: UIAlertAction) in
            if okClosure != nil {
                okClosure!()
            }
        })
        alertController.addAction(yesAction)

        self.present(alertController, animated: true, completion: nil)
    }
     
    func showAlert(_ message: String!) {
        showAlertDialog(title: "Alert", message: message, positive: "OK", negative: nil)
    }
    
    //MARK: -
    func hideKeyboardWhenTappedAround() {

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        self.tap = tap
        view.addGestureRecognizer(tap)
    }

    func keepKeyboardShowing() {
        if let tapGes = self.tap {
            view.removeGestureRecognizer(tapGes)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
