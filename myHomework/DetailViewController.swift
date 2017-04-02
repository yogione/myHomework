//
//  DetailViewController.swift
//  myHomework
//
//  Created by Srini Motheram on 4/1/17.
//  Copyright © 2017 Srini Motheram. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class DetailViewController: UIViewController {
    
    @IBOutlet var homeworkNameTextField :UITextField!
    @IBOutlet var hwdescTextField       :UITextField!
    @IBOutlet var dueDateDatePicker     :UIDatePicker!
    @IBOutlet var reminderDateDatePicker    :UIDatePicker!
    @IBOutlet var completionStatusTextField          :UITextField!
    
    var currentHomework :Homework?
    
     let eventStore = EKEventStore()
    
    var managedContext  :NSManagedObjectContext!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK:- CORE DATA METHODS
    func setHomeworkValues(homework: Homework) {
        homework.homeWorkName = homeworkNameTextField.text
        homework.hwdesc = hwdescTextField.text
        homework.dueDate = dueDateDatePicker.date as NSDate?
        homework.reminderDate = reminderDateDatePicker.date as NSDate?
        homework.completionStatus = completionStatusTextField.text
       
    }
    
    func createHomework() {
        let newHomework = NSEntityDescription.insertNewObject(forEntityName: "Homework", into: managedContext) as! Homework
        setHomeworkValues(homework: newHomework)
        appDelegate.saveContext()
    }
    
    func editHomework(homework: Homework) {
            setHomeworkValues(homework: homework)
            appDelegate.saveContext()
        
    }
    
    //MARK: - Interactivity Methods
    
    @IBAction func savedPressed(button: UIBarButtonItem) {
        if let homework = currentHomework {
            editHomework(homework: homework)
        } else {
            createHomework()
        }
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Reminder Methods
    
    @IBAction func createReminder(button: UIBarButtonItem) {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        reminder.title = homeworkNameTextField.text!
        let alarm = EKAlarm(absoluteDate: reminderDateDatePicker.date)
        reminder.addAlarm(alarm)
      //  if let latText = latTextField.text, let lonText = lonTextField.text, let lat = Double(latText), let lon = Double(lonText) {
        //    let locAlarm = EKAlarm()
          //  let ekLoc = EKStructuredLocation(title: "Home")
          //  let loc = CLLocation(latitude: lat, longitude: lon)
          //  ekLoc.geoLocation = loc
          //  ekLoc.radius = 500
          //  locAlarm.structuredLocation = ekLoc
          //  locAlarm.proximity = .enter
          //  reminder.addAlarm(locAlarm)
       // }
        do {
            try eventStore.save(reminder, commit: true)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func findReminders(button: UIBarButtonItem) {
        let reminderLists = eventStore.calendars(for: .reminder)
        let predicate = eventStore.predicateForReminders(in: reminderLists)
        eventStore.fetchReminders(matching: predicate) { (reminders) in
            if let count = reminders?.count, count > 0 {
                for reminder in reminders! {
                    print(reminder.title)
                }
            } else {
                print("No Reminders")
            }
        }
    }
    //MARK: - Permission Methods
    
    func requestAccessToEKType(type: EKEntityType) {
        eventStore.requestAccess(to: type) { (accessGranted, error) -> Void in
            if accessGranted {
                print("Granted \(type.rawValue)")
            } else {
                print("Not Granted")
            }
        }
    }
    
    func checkEKAuthorizationStatus(type: EKEntityType) {
        let status = EKEventStore.authorizationStatus(for: type)
        switch status {
        case .notDetermined:
            print("Not Determined")
            requestAccessToEKType(type: type)
        case .authorized:
            print("Authorized")
        case .restricted, .denied:
            print("Restricted/Denied")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.persistentContainer.viewContext

            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    
}
