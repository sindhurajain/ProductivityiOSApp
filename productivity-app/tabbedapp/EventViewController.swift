//
//  NoteViewController.swift
//  tabbedapp
//
//  Created by Sindhura Jain on 10/12/20.
//  Copyright © 2020 Sindhura Jain. All rights reserved.
//
import RealmSwift

import UIKit

class EventViewController: UIViewController {
   public var eventinfo: EventInfo?
    public var deletionHandler: (() -> Void)?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var eventLabel: UITextView!
    
    private let realm = try! Realm()

  public var eventTitle: String = "" //og
  public var event: String = "" //og

  
    override func viewDidLoad() {
        super.viewDidLoad()
       

//titleLabel.text = eventTitle //og
//eventLabel.text = event //og
      //  itemLabel.text = item?.item (changed)
   

        
        titleLabel.text = eventTitle
        eventLabel.text = event

   // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))

    }
@objc private func didTapDelete() {

 guard let myItem = self.eventinfo else{
            return
        }
                
        realm.beginWrite()
        realm.delete(myItem)
     
        try! realm.commitWrite()
        
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
    }

        
}

