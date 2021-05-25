//
//  SelectedCountry+CoreDataProperties.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 24/05/21.
//
//

import Foundation
import CoreData


extension SelectedCountry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SelectedCountry> {
        return NSFetchRequest<SelectedCountry>(entityName: "SelectedCountry")
    }

    @NSManaged public var active: Int64
    @NSManaged public var city: String
    @NSManaged public var cityCode: String
    @NSManaged public var confirmed: Int64
    @NSManaged public var country: String
    @NSManaged public var countryCode: String
    @NSManaged public var date: String
    @NSManaged public var deaths: Int64
    @NSManaged public var lat: String
    @NSManaged public var lon: String
    @NSManaged public var province: String
    @NSManaged public var recovered: Int64

}

extension SelectedCountry : Identifiable {

}
