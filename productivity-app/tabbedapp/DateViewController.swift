//
//  DateViewController.swift
//  tabbedapp
//
//  Created by Sindhura Jain on 28/11/20.
//  Copyright © 2020 Sindhura Jain. All rights reserved.
//

import UIKit

class DateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var field: UITextField!
    @IBOutlet var picker: UIDatePicker!

    public var completionHandler: ((String, Date) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        field.becomeFirstResponder()
        picker.tintColor = .black
        field.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder()
        return true
    }
    
    

    @objc func didTapSaveButton() {
        if let text = field.text, !text.isEmpty {
            let pickedDatetime =  picker.date
            completionHandler?(text, pickedDatetime)
            navigationController?.popToRootViewController(animated: true)
            
        }
    }
}
