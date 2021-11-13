//
//  UserModel.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 03/04/1443 AH.
//

import Foundation



struct UserModel {
    var id: Int32?
    var username: String?
    var email: String? = nil
    var password: String?
    var type: String = "customer"
    var token: String?

    init(id: Int32?, username: String?, email: String?, type: String = "customer", password: String? = nil, token: String? = nil) {
        self.id         = id
        self.username   = username
        self.email      = email
        self.type       = type
        self.password   = password
        self.token      = token
    }
}
