//
//  Brain.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 26.01.2023.
//

import Foundation

let AccountMenu = ["📦 Siparişlerim","💛 Beğendiklerim","🏠 Adreslerim","🎟 Kuponlarım","🎮 Oyna Kazan","💬 Geri Bildirim","🚪 Çıkış Yap"]
let DeveloperMenu = ["Ürün ekle","Ürünler","Kullanıcılar","Geri Bildirimler","Siparişler"]

let city = ["İstanbul","İzmir","Ankara","Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Amasya", "Antalya", "Artvin", "Aydın", "Balıkesir", "Bilecik", "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum", "Denizli", "Diyarbakır", "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir", "Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Isparta", "Mersin", "Kars", "Kastamonu", "Kayseri", "Kırklareli", "Kırşehir", "Kocaeli", "Konya", "Kütahya", "Malatya", "Manisa", "Kahramanmaraş", "Mardin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Rize", "Sakarya", "Samsun", "Siirt", "Sinop", "Sivas", "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Şanlıurfa", "Uşak", "Van", "Yozgat", "Zonguldak", "Aksaray", "Bayburt", "Karaman", "Kırıkkale", "Batman", "Şırnak", "Bartın", "Ardahan", "Iğdır", "Yalova", "Karabük", "Kilis", "Osmaniye", "Düzce"]

var User = [
    UserInfo(name: "", surname: "", phoneNumber: "", email: "")
]
var UsersAddress = [UserAddress(address: "", city: "", name: "", phoneNumber: "", title: "")]


//Kullanıcının adresleri
var addresses = [UserAddress]()
