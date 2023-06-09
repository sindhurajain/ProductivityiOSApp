//
//  NewEvent.swift
//  tabbedapp
//
//  Created by Sindhura Jain on 10/12/20.
//  Copyright © 2020 Sindhura Jain. All rights reserved.
//
import RealmSwift

import UIKit

class NewEvent: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var eventField: UITextView!

    
    private let realm = try! Realm()

    public var completion: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        eventField.becomeFirstResponder()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    func textFieldShouldReturn(_ titleField: UITextField) -> Bool { titleField.resignFirstResponder()
        return true
    }
    func eventFieldShouldReturn(_ textField: UITextField) -> Bool { eventField.resignFirstResponder()
        return true
    }
    
    
    @objc func didTapSave(){
      
       

        if let text = titleField.text, !text.isEmpty, !eventField.text.isEmpty{
            realm.beginWrite()
            
            let newItem = EventInfo()
            newItem.title = text
            newItem.event = eventField.text

            realm.add(newItem)
            
            try! realm.commitWrite()
        
            
            completion?(text, eventField.text)
            
        }
    }

    
}
