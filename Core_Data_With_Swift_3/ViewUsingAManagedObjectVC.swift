//
//  ViewUsingAManagedObjectVC.swift
//  Core_Data_With_Swift_3
//
//  Created by Franks, Kent on 4/11/17.
//  Copyright © 2017 Franks, Kent. All rights reserved.
//

import UIKit
import CoreData

class ViewUsingAManagedObjectVC: UIViewController {

    @IBOutlet weak var employeeTitleTextField: UITextField!
    @IBOutlet weak var employeeFirstNameTextField: UITextField!
    @IBOutlet weak var employeeLastNameTextField: UITextField!

    let persistenceStack = PersistenceStack.sharedStack

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAccount()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        print("🤖 employeeTitle = \(employeeTitleTextField.text!), firstName = \(employeeFirstNameTextField.text!), lastName = \(employeeLastNameTextField.text!)")
        
        let employeeEntityDescription = NSEntityDescription.entity(forEntityName: "Employee", in: persistenceStack.mainMoc)
        let employee = EmployeeMO(entity: employeeEntityDescription!, insertInto: persistenceStack.mainMoc)
        employee.title = employeeTitleTextField.text
        employee.firstName = employeeFirstNameTextField.text
        employee.lastName = employeeLastNameTextField.text
        
        do {
            try persistenceStack.mainMoc.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }

        employeeTitleTextField.text = ""
        employeeFirstNameTextField.text = ""
        employeeLastNameTextField.text = ""
    }
    
    func fetchAccount() {
        
        let employeeFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Employee")
        do {
            if let fetchedAccounts = try persistenceStack.mainMoc.fetch(employeeFetchRequest) as? [EmployeeMO] {
                for employee in fetchedAccounts  {
                    print("🤖 title = \(employee.title!)")
                    print("🤖 firstName = \(employee.firstName!)")
                    print("🤖 lastName = \(employee.lastName!)")
                }
            }
        } catch {
            print("Error fetching results")
        }
        
    }

    
}
