//
//  Product+CoreDataProperties.swift
//  The Tasarım
//
//  Created by Şeyda Soylu on 2.04.2023.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var image2: Data?
    @NSManaged public var image1: Data?
    @NSManaged public var image3: Data?
    @NSManaged public var rate: Double
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Double
    @NSManaged public var detail: String?
    @NSManaged public var price: String?
    @NSManaged public var category: String?

}

extension Product : Identifiable {

}
