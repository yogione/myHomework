//
//  ViewController.swift
//  myHomework
//
//  Created by Srini Motheram on 3/30/17.
//  Copyright © 2017 Srini Motheram. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var homeworks: [NSManagedObject] = []
    
  //  var homeworkArray = [Homework]()
    
    var managedContext :NSManagedObjectContext!

    @IBOutlet var homeworkTableView :UITableView!
    
    
    //MARK: - Interavtivity Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditTask" {
            let indexPath = homeworkTableView.indexPathForSelectedRow!
            let currentHomework = homeworks[indexPath.row]
            let destVC = segue.destination as! DetailViewController
            destVC.currentHomework = currentHomework
            homeworkTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func updateScreen() {
        homeworkTableView.reloadData()
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//MARK: - TableView Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return homeworks.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    // let currentContact = contactArray[indexPath.row]
    let currentHomework = homeworks[indexPath.row]
    print("\(currentHomework)")

  //  cell.textLabel!.text = currentContact.lastName! + ", " + currentContact.firstName!
   // cell.detailTextLabel!.text = currentContact.phoneNumber!
    return cell
}

func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
}

func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        let homeworkToDelete = homeworks[indexPath.row]
        managedContext.delete(homeworkToDelete)
        appDelegate.saveContext()
       // contactArray = appDelegate.fetchAllContacts()
        homeworks = appDelegate.fetchAllHomeWorks()
        homeworkTableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.isEditing = false
    }
}

}

