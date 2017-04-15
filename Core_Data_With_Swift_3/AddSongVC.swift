//
//  AddSongVC.swift
//  Core_Data_With_Swift_3
//
//  Created by Franks, Kent on 4/11/17.
//  Copyright © 2017 Franks, Kent. All rights reserved.
//

import UIKit
import CoreData

class AddSongVC: UIViewController {

    @IBOutlet weak var addArtistTextField: UITextField!
    @IBOutlet weak var addGenreTextField: UITextField!
    @IBOutlet weak var addSongTextField: UITextField!

    let persistenceStack = PersistenceStack.sharedStack

    var managedObjectContext: NSManagedObjectContext?
    var persistentContainer: NSPersistentContainer?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAccount()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        print("🤖 song = \(addSongTextField.text!), artist = \(addArtistTextField.text!), genre = \(addGenreTextField.text!)")

        guard let managedObjectContext = managedObjectContext else {
            return
        }

        // Create Song
        let song = Song(context: managedObjectContext)
        
        // Configure Song
        song.songTitle = addSongTextField.text
        song.genre = addGenreTextField.text
        song.artist = addArtistTextField.text
        
        do {
            try persistentContainer?.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
        
        addSongTextField.text = ""
        addArtistTextField.text = ""
        addGenreTextField.text = ""
        
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)

    }
    
    func fetchAccount() {
        
        let songRequest = NSFetchRequest<Song>(entityName: "Song")
        do {
            let items = try persistenceStack.mainMoc.fetch(songRequest)
            for song in items {
                print("🤖 songTitle = \(song.songTitle!)")
                print("🤖 genre = \(song.genre!)")
                print("🤖 artist = \(song.artist!)")
            }
        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
    
    }

}
