//
//  TableUsingFetchedResultsController.swift
//  Core_Data_With_Swift_3
//
//  Created by Franks, Kent on 4/11/17.
//  Copyright © 2017 Franks, Kent. All rights reserved.
//

import UIKit
import CoreData

class TableUsingFetchedResultsController: UIViewController {

    @IBOutlet weak var songTableView: UITableView!

    private let persistentContainer = NSPersistentContainer(name: "KefTestModel")
    let persistenceStack = PersistenceStack.sharedStack
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Song> = {

        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "songTitle", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                self.setupView()
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                self.updateView()
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    
    // MARK: - Setup UI
    
    fileprivate func updateView() {
        var hasSongs = false
        if let songs = fetchedResultsController.fetchedObjects {
            hasSongs = songs.count > 0
        }
        songTableView.isHidden = !hasSongs
    }
    
    private func setupView() {
        updateView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSongSegue" {
            if let destinationViewController = segue.destination as? AddSongVC {
                destinationViewController.managedObjectContext = persistentContainer.viewContext
                destinationViewController.persistentContainer = persistentContainer
            }
        }
    }

    
}

// MARK: - ViewController Extension

extension TableUsingFetchedResultsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let songs = fetchedResultsController.fetchedObjects else { return 0 }
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.reuseIdentifier, for: indexPath) as? SongTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Quote
        let song = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.artistLabel.text = song.artist
        cell.genreLabel.text = song.genre
        cell.songLabel.text = song.songTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Account
            let song = fetchedResultsController.object(at: indexPath)
            
            // Delete Quote
            song.managedObjectContext?.delete(song)
        }
    }
}

extension TableUsingFetchedResultsController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        songTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        songTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                songTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                songTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }
    
}

