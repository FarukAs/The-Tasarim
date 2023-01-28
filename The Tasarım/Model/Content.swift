//
//  Content.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//

import Foundation


class UserInfo {
    let name: String
    let surname: String
    let phoneNumber: String
    let email: String

    init(name: String, surname: String, phoneNumber: String, email: String) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.email = email
    }

    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "surname": surname,
            "phoneNumber": phoneNumber,
            "email": email,
        ]
    }
}


