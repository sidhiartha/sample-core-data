//
//  CreateViewController.swift
//  SampleCoreData
//
//  Created by Sidhi Artha on 05/02/18.
//  Copyright © 2018 Sidhi Artha. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var descField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: Any)
    {
        guard let phone = phoneField.text, phone != "" else
        {
            let alert = UIAlertController(title: "Warning", message: "Phone number cannot be empty", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
            
            return
        }
        
        let dictionary = ["name": nameField.text!, "phone": phoneField.text!, "desc" : descField.text!]
        
        let addressBookEntity = CoreDataManager.shared.loadOrCreate(entityName: "AddressBookEntity", by: dictionary) as! AddressBookEntity
        addressBookEntity.name = nameField.text
        addressBookEntity.phone = phoneField.text
        addressBookEntity.desc = descField.text
        
        CoreDataManager.shared.saveContext()
        
        nameField.text = ""
        phoneField.text = ""
        descField.text = ""
    }
}
