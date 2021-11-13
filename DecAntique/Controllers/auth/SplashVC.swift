//
//  SplashVC.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 04/04/1443 AH.
//

import UIKit

class SplashVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        perform(#selector(gotoLogin), with: self, afterDelay: 1)
    }
    
    @objc func gotoLogin() {
        let email = userDefaluts.string(forKey: "user_email")
        if email == nil || email == "" {
            gotoVC("AuthNav", true)
        } else {
            gotoVC("TabbarVC", true)
        }
    }

}
