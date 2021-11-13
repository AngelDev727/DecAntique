//
//  CommomUtil.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 04/04/1443 AH.
//

import Foundation

func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}
