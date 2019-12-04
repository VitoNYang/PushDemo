//
//  ViewController.swift
//  PushDemo
//
//  Created by GZOffice_hao on 2019/12/2.
//  Copyright © 2019 vito. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var dateInputField: UITextField!
    
    private lazy var datePicker = makeDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    @IBAction func send(sender: UIButton) {
        guard let message = messageInput.text, let date = dateInputField.text?.toDate() else {
            return
        }
        let calendar = Calendar.current
        let component = calendar.dateComponents(.init(arrayLiteral: .month, .day, .hour, .minute), from: date)
        
        let content = UNMutableNotificationContent()
        content.body = message
        content.badge = 1
        content.categoryIdentifier = "categoryidentifier"
        // 在 设定时间 后推送本地推送
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        let request = UNNotificationRequest(identifier: "push", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("request error > \(error.localizedDescription)")
            } else {
                print("request success")
            }
        }
    }

}

extension ViewController {
    
    private func setupViews() {
        dateInputField.inputView = datePicker
        dateInputField.inputAccessoryView = makeToolbar()
        dateInputField.delegate = self
        dateInputField.tintColor = .clear
    }
    
    private func makeDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        let currentDate = Date()
        let calendar = Calendar.current
        let maximumDate = calendar.date(byAdding: .year, value: 1, to: currentDate)
        datePicker.minimumDate = currentDate
        datePicker.maximumDate = maximumDate
        datePicker.locale = Locale(identifier: "zh-CH")
        datePicker.sizeToFit()
        return datePicker
    }
    
    private func makeToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        toolbar.items = [cancelItem, spaceItem, doneItem]
        toolbar.sizeToFit()
        return toolbar
    }
    
    @objc private func cancelAction() {
        view.endEditing(true)
    }
    
    @objc private func doneAction() {
        dateInputField.text = datePicker.date.toDisplayString()
        view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.toDate() != nil
    }
}
