//
//  Stock+CoreDataProperties.swift
//  Stockcuk
//
//  Created by Erkan on 27.11.2022.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var price: Int32
    @NSManaged public var numbers: Int32
    @NSManaged public var image: Data?
    @NSManaged public var type: String?

}

extension Stock : Identifiable {

}
