//
//  SaveAnArrayVC.swift
//  Core_Data_With_Swift_3
//
//  Created by Franks, Kent on 4/15/17.
//  Copyright © 2017 Franks, Kent. All rights reserved.
//

import UIKit
import CoreData

class SaveAnArrayVC: UIViewController {

    let persistenceStack = PersistenceStack.sharedStack
    
    let arrayOfQuestionNumbers = [1,2,3,4,5]

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAccount()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        print("🤖 saveAction")
        let category = Category(context: persistenceStack.mainMoc)
        category.questions = arrayOfQuestionNumbers as NSObject?
        category.title = "Finish the lyric"
        
        do {
            try persistenceStack.mainMoc.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }

    }
    
    func fetchAccount() {
        
        let categoryRequest = NSFetchRequest<Category>(entityName: "Category")
        do {
            let categories = try persistenceStack.mainMoc.fetch(categoryRequest)
            for category in categories {
                print("🤖 title = \(category.title!)")
                let questions = category.questions as! [Int]
                for questionId in questions {
                    print("🤖 questionId = \(questionId)")
                }
                
            }
        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        
    }

    

}
