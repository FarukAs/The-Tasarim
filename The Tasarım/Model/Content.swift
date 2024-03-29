//
//  Content.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//

import Foundation
import UIKit


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
class UserAddress{
    let address: String
    let city: String
    let name: String
    let surname: String
    let phoneNumber: String
    let title: String
    
    init(address: String, city: String, name: String,surname:String, phoneNumber: String, title: String) {
        self.address = address
        self.city = city
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.title = title
    }
}
class Coupons{
    let category: String
    let limit: String
    let price: String
    
    init(category: String, limit: String, price: String) {
        self.category = category
        self.limit = limit
        self.price = price
    }
}
class categorBrain{
    let categoryName: String
    let categoryImage: UIImage
    
    init(categoryName: String, categoryImage: UIImage) {
        self.categoryName = categoryName
        self.categoryImage = categoryImage
    }
}
class productBrain{
    
    var productCategory: String
    var productName: String
    var productDetail: String
    var productPrice: String
    var averageRate: Double
    var timestamp: Double
    var image1: UIImage
    var image2: UIImage
    var image3: UIImage
    
    init(productCategory: String, productName: String, productDetail: String, productPrice: String,averageRate: Double,timestamp: Double, image1: UIImage, image2: UIImage, image3: UIImage) {
        self.productCategory = productCategory
        self.productName = productName
        self.productDetail = productDetail
        self.productPrice = productPrice
        self.averageRate = averageRate
        self.timestamp  = timestamp
        self.image1 = image1
        self.image2 = image2
        self.image3 = image3
    }
}
class commentBrain{
    var Comment: String
    var Date: Double
    var Rate: Double
    var Name: String
    var Documentid: String
    
    init(Comment: String, Date: Double, Rate: Double, Name: String,Documentid: String) {
        self.Comment = Comment
        self.Date = Date
        self.Rate = Rate
        self.Name = Name
        self.Documentid = Documentid
    }
}
struct Feedback {
    let userEmail: String
    let timestamp:  Date
    let text: String
    let imageData: UIImage
}
class UserDefaultsKeys {
    var givenName :String
    var familyName :String
    var email :String
    var phoneNumber : String
    
    init(givenName: String, familyName: String, email: String, phoneNumber: String) {
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
        self.phoneNumber = phoneNumber
    }
}


struct prdct {
    let name : String
    let timestamp : Int
}
struct QuestionProductModel:Hashable {
    let category: String
    let productName: String
    let senderName: String
    let Product:String
}

struct QuestionAnswerModel:Hashable {
    let question: String
    let askerName: String
    let askerEmail: String
    let questionDate: Double
    let answer: String
    let sellerName: String
    let answerDate: Double
    let isAnonymus: Bool
    let answered: Bool
    let title: String
    let productName: String
    let productCategory: String
}
