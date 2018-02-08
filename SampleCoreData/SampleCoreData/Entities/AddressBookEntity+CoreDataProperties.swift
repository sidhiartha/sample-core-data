//
//  AddressBookEntity+CoreDataProperties.swift
//  SampleCoreData
//
//  Created by Sidhi Artha on 07/02/18.
//  Copyright © 2018 Sidhi Artha. All rights reserved.
//
//

import Foundation
import CoreData


extension AddressBookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddressBookEntity> {
        return NSFetchRequest<AddressBookEntity>(entityName: "AddressBookEntity")
    }

    @NSManaged public var desc: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?

}
