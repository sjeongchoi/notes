//
//  noteTableViewController.swift
//  Notes
//
//  Created by jin on 2018. 7. 11..
//  Copyright © 2018년 jin. All rights reserved.
//

import UIKit
import CoreData

class noteTableViewController: UITableViewController {
    
    var notes = [Note]()
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieveNotes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : noteTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! noteTableViewCell

        let note: Note = notes[indexPath.row]
        cell.configureCell(note: note)
        cell.backgroundColor = UIColor.clear

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }

    func retrieveNotes(){
        managedObjectContext?.perform {
            self.fetchNotesFromCoreData{ (notes) in
                if let notes = notes {
                    self.notes = notes
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchNotesFromCoreData(completion: @escaping ([Note]?) -> Void) {
        managedObjectContext?.perform {
            var notes = [Note]()
            let request : NSFetchRequest<Note> = Note.fetchRequest()
            
            do {
                notes = try self.managedObjectContext!.fetch(request)
                completion(notes)
            }
            catch {
                print("Could not fetch notes from CoreData : \(error.localizedDescription)")
            }
        }
    }
    
}
