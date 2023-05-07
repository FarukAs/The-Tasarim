//
//  Brain.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//

import Foundation
import UIKit

let AccountMenu = ["📦 Siparişlerim","💛 Favorilerim","🏠 Adreslerim","🎟 Kuponlarım","🎮 Oyna Kazan","👤 Hesabım","💬 Geri Bildirim","🚪 Çıkış Yap"]

let DeveloperMenu = ["Tüm Ürünler","Listelenen Ürünler","Siparişler","Kullanıcılar","Ürün Soru-Cevap","Geri Bildirimler"]

let city = ["","İstanbul","İzmir","Ankara","Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Amasya", "Antalya", "Artvin", "Aydın", "Balıkesir", "Bilecik", "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum", "Denizli", "Diyarbakır", "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir", "Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Isparta", "Mersin", "Kars", "Kastamonu", "Kayseri", "Kırklareli", "Kırşehir", "Kocaeli", "Konya", "Kütahya", "Malatya", "Manisa", "Kahramanmaraş", "Mardin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Rize", "Sakarya", "Samsun", "Siirt", "Sinop", "Sivas", "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Şanlıurfa", "Uşak", "Van", "Yozgat", "Zonguldak", "Aksaray", "Bayburt", "Karaman", "Kırıkkale", "Batman", "Şırnak", "Bartın", "Ardahan", "Iğdır", "Yalova", "Karabük", "Kilis", "Osmaniye", "Düzce"]

var User = [
    UserInfo(name: "", surname: "", phoneNumber: "", email: "")
]
var UsersAddress = [UserAddress(address: "", city: "", name: "",surname: "", phoneNumber: "", title: "")]


//Kullanıcının adresleri
var addresses = [UserAddress]()

var coupon = [Coupons(category: "Tüm ürünlerde geçerli", limit: "100 TL ve üzerine", price: "5 TL"),
Coupons(category: "Mutfak gereçlerinde geçerli", limit: "150 TL ve üzerine.", price: "20 TL"),
Coupons(category: "Banyo gereçlerinde geçerli", limit: "200 TL ve üzerine", price: "40 TL")]

var numberOfData = 0
//
//var categoryNames = [String]()
//var categoryImages = [UIImage]()

var categoryArray = [categorBrain(categoryName: "", categoryImage: UIImage(named: "logo")!)]
var productArray = [productBrain(productCategory: "", productName: "", productDetail: "", productPrice: "", averageRate: 5.6, timestamp: 1234, image1: UIImage(named: "logo")!, image2: UIImage(named: "logo")!, image3: UIImage(named: "logo")!)]

var collectionViewData = [productBrain(productCategory: "", productName: "", productDetail: "", productPrice: "", averageRate: 5, timestamp: 1234, image1: UIImage(named: "logo")!, image2: UIImage(named: "logo")!, image3: UIImage(named: "logo")!)]

var productCategories = [""]
var products = [""]

var selectedItem = 1000


var commentsBrain = [commentBrain(Comment: "", Date: 0.0, Rate: 0.0, Name: "",Documentid: "")]

var feedbacks: [Feedback] = []

var td_currentuser = UserDefaultsKeys(givenName: "", familyName: "", email: "", phoneNumber: "")

var userFavorites = [productBrain(productCategory: "", productName: "", productDetail: "", productPrice: "", averageRate: 5, timestamp: 1234, image1: UIImage(named: "logo")!, image2: UIImage(named: "logo")!, image3: UIImage(named: "logo")!)]
var listedProducts: [String] = []

var questionAnswerData = [QuestionAnswerModel(question: "", askerName: "",askerEmail: "", questionDate: 0, answer: "", sellerName: "", answerDate: 0, isAnonymus: false, answered: false,title: "",productName: "",productCategory: "")]

var unansweredQuestions = [QuestionAnswerModel]()
var unansweredProducts = [String()]
var unansweredProductsInfo = [QuestionProductModel]()
