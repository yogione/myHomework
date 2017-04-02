//
//  HomeworksTableViewCell.swift
//  myHomework
//
//  Created by Srini Motheram on 4/2/17.
//  Copyright © 2017 Srini Motheram. All rights reserved.
//

import UIKit
import CoreData

class HomeworksTableViewCell: UITableViewCell {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var homeworkNameLabel         :UILabel!
    @IBOutlet var hwdescLabel               :UILabel!
    @IBOutlet var completionStatusLabel     :UILabel!
    @IBOutlet var dueDateLable              :UILabel!
    @IBOutlet var reminderDateLable         :UILabel!

}
