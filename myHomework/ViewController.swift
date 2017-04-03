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
    var managedContext :NSManagedObjectContext!
    
   // var homeworks: [NSManagedObject] = []
    var homeworkArray = [Homework]()

    @IBOutlet var homeworkTableView :UITableView!    
    
    //MARK: - Interavtivity Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToEditSelectedHW" {
            let indexPath = homeworkTableView.indexPathForSelectedRow!
            let currentHomework = homeworkArray[indexPath.row]
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeworkArray = appDelegate.fetchAllHomeWorks()
        print("Count \(homeworkArray.count)")
        homeworkTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

//MARK: - TableView Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return homeworkArray.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HomeworksTableViewCell
    // let currentContact = contactArray[indexPath.row]
    let currentHomework = homeworkArray[indexPath.row]
    print("\(currentHomework)")

  //  cell.textLabel!.text = currentContact.lastName! + ", " + currentContact.firstName!
   // cell.detailTextLabel!.text = currentContact.phoneNumber!
    cell?.homeworkNameLabel.text = currentHomework.homeWorkName
    cell?.hwdescLabel.text = currentHomework.hwdesc
    cell?.dueDateLable.text = "\(currentHomework.dueDate)"
    cell?.reminderDateLable.text = "\(currentHomework.reminderDate)"
    cell?.completionStatusLabel.text = currentHomework.completionStatus
    
    return cell!
}

func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
}

func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        let homeworkToDelete = homeworkArray[indexPath.row]
        managedContext.delete(homeworkToDelete)
        appDelegate.saveContext()
       // contactArray = appDelegate.fetchAllContacts()
        homeworkArray = appDelegate.fetchAllHomeWorks()
        homeworkTableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.isEditing = false
    }
}

}

