//
//  EmployeeMO+CoreDataProperties.swift
//  Core_Data_With_Swift_3
//
//  Created by Franks, Kent on 4/12/17.
//  Copyright © 2017 Franks, Kent. All rights reserved.
//

import Foundation
import CoreData


extension EmployeeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeMO> {
        return NSFetchRequest<EmployeeMO>(entityName: "Employee");
    }

    @NSManaged public var title: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

}
