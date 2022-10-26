//
//  KidTableViewCell.swift
//  Habitica
//
//  Created by Surya Pratap Singh on 22/09/22.
//  Copyright © 2022 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models

class KidTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPrayer: UILabel!
    @IBOutlet weak var lblPrayerTime: UILabel!
    @IBOutlet weak var lblKidPrayerTime: UILabel!
    @IBOutlet weak var lblPrayerScore: UILabel!
    
    var numArr = ["0.", "1.", "2.", "3.", "4."]
    var nameArr = [" Fajr ", " Zuhr ", " Asr", " Maghrib", " Isha"]
    var startTimeArr = ["5:00 AM", "5:00 AM", "1:00 PM", "4:00 PM", "6:00 PM", "9:00 PM"]
    var endTimeArr = ["5:00 AM", "5:00 AM", "1:20 PM", "4:10 PM", "6:00 PM", "9:20 PM"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc
    func configure(task: TaskProtocol, indexPath: IndexPath) {
        if !task.isValid {
            return
        }
        
        if let text = task.text {
            self.lblPrayer.text = "\(indexPath.row). " + text.unicodeEmoji
        }

//        if let startDate = task.startDate {
//            self.lblPrayerTime.text = "\(startDate)"
//        } else {
//            self.lblPrayerTime.text = "-"
//        }
//
//        if let duedate = task.duedate {
//            self.lblKidPrayerTime.text = "\(duedate)"
//        } else {
//            self.lblKidPrayerTime.text = "-"
//        }

        self.lblPrayerScore.text = "\(task.streak)"
        
        
//        self.lblPrayer.text = "\(numArr[indexPath.row])" + "\(nameArr[indexPath.row])"
        self.lblPrayerTime.text = "\(startTimeArr[indexPath.row])"//"5:00 AM"
        self.lblKidPrayerTime.text = "\(endTimeArr[indexPath.row])"//"6:00 AM"
//        self.lblPrayerScore.text = "10"
        
    }
}
