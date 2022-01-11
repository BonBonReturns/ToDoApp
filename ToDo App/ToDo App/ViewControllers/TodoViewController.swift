//
//  TodoViewController.swift
//  ToDo App
//
//  Created by Ayush Tiwari on 19/02/21.
//

import UIKit
import UserNotifications

protocol todoEditDelegate: class {
    func didTapSave(newText: String, index: Int?, notifTime: Date?)
    func didCreateNotif(identifier: String, index: Int?)
    func getNotifIdentifier(index: Int) -> String
}

class TodoViewController: UIViewController, UNUserNotificationCenterDelegate {

    var originalText: String?
    var index: Int?
    weak var delegate: todoEditDelegate?
    var headingType: String?
    var notificationTime: Date?
    var reminderColor: Int?
    
    @IBOutlet weak var beepSwitch: UISwitch!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var editNoteTextField: UITextView!
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editNoteTextField.text = originalText
        editNoteTextField.becomeFirstResponder()
        headingLabel.text = headingType!
        setUpDatePicker()
        setReminderColor()
        getPermissions()
    }
    
    @IBAction func datePickerNotif(_ sender: Any) {
        notificationTime = datePicker.date
        beepSwitch.isOn = true
    }
    
    @IBAction func didTapSwitch(_ sender: Any) {
        if !beepSwitch.isOn {
            print("Swift turned off")
            if let idx = index  {
                deleteNotif(index: idx)
            }
        }
    }
    
    @IBAction func editNoteBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editNoteSaveButton(_ sender: Any) {
        if(beepSwitch.isOn) {
            delegate?.didTapSave(newText: editNoteTextField.text, index: index, notifTime: datePicker.date)
            if let notifTime = notificationTime {
                if let idx = index {
                    deleteNotif(index: idx)
                }
                scheduleNotification(at: notifTime, body: editNoteTextField.text, titles: "Reminder", index: index)
            }
        } else {
            delegate?.didTapSave(newText: editNoteTextField.text, index: index, notifTime: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension TodoViewController {
    
    func scheduleNotification(at date: Date?, body: String, titles:String, index: Int?) {
        let triggerDaily = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = titles
        content.body = body
        content.sound = .defaultCritical
        content.categoryIdentifier = "todoList"
        content.badge = 1

        let uniqueIdentifier = String((date?.timeIntervalSince1970)!)
        
        delegate?.didCreateNotif(identifier: uniqueIdentifier, index: index)
        let request = UNNotificationRequest(identifier: uniqueIdentifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print(" We had an error: \(error)")
            }
        }
        print("Notif created")
    }
    
    func getPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    func deleteNotif(index: Int) {
        let notifIdentifier: String? = delegate?.getNotifIdentifier(index: index)
        if notifIdentifier != "" {
            if let notifIden = notifIdentifier {
                print("Printing notifIden \(notifIden)")
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifIden])
            } else {
                print("Cannot delete Notif or it didnt exist")
            }
        } else {
            print("Identifier nil")
        }
    }
}

extension TodoViewController {
    func setReminderColor() {
        if reminderColor == nil {
            reminderView.backgroundColor = .systemTeal
        } else {
            reminderView.backgroundColor = UIColor(reminderColor!)
        }
    }
}

extension TodoViewController {
    func setUpDatePicker() {
        if let tempTime = notificationTime {
            datePicker.setDate(tempTime, animated: true)
        } else {
            let midDayTime = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
            datePicker.setDate(midDayTime!, animated: false)
        }
        if originalText != nil && notificationTime == nil {
            beepSwitch.isOn = false
        }
    }
}
