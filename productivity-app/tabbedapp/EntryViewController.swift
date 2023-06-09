//
//  EntryViewController.swift
//  tabbedapp
//
//  Created by Sindhura Jain on 29/11/20.
//  Copyright © 2020 Sindhura Jain. All rights reserved.
//
import RealmSwift
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    private let realm = try! Realm()
    public var completionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        textField.delegate = self
        
        
       
        if datePicker != nil {
            datePicker.setDate(Date(), animated: true)
            datePicker.tintColor = .black

        } else {
            print("No value")
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
        
    }
    @objc func didTapSaveButton() {
        if let text = textField.text, !text.isEmpty{
            let date = datePicker.date

            realm.beginWrite()
            
            let newItem = ToDoListItem()
            newItem.date = date
            newItem.item = text
            realm.add(newItem)
            
            try! realm.commitWrite()
            
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        }
        
        else{
            print("Add something")
        }
            
           

        
    }
    
}


