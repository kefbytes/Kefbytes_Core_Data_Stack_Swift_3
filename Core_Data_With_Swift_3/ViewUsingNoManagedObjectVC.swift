//
//  ViewUsingNoManagedObjectVC.swift
//  Core_Data_With_Swift_3
//
//  Created by Franks, Kent on 4/11/17.
//  Copyright © 2017 Franks, Kent. All rights reserved.
//

import UIKit
import CoreData

class ViewUsingNoManagedObjectVC: UIViewController {

    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let persistenceStack = PersistenceStack.sharedStack

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAccount()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        print("🤖 accountName = \(accountNameTextField.text!), username = \(usernameTextField.text!), password = \(passwordTextField.text!)")
        
        
        let account = Account(context: persistenceStack.privateMoc)
        account.accountName = accountNameTextField.text
        account.username = usernameTextField.text
        account.password = passwordTextField.text
        
        do {
            try persistenceStack.privateMoc.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
        
        accountNameTextField.text = ""
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    func fetchAccount() {
        
        let accountRequest = NSFetchRequest<Account>(entityName: "Account")
        persistenceStack.persistentContainer.performBackgroundTask { (context) in
            do {
                let items = try context.fetch(accountRequest)
                for account in items {
                    print("🤖 accountName = \(account.accountName!)")
                    print("🤖 username = \(account.username!)")
                    print("🤖 password = \(account.password!)")
                }

            } catch let error as NSError {
                print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
            }
        }
    }
    
}
