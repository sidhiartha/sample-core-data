//
//  DetailViewController.swift
//  SampleCoreData
//
//  Created by Sidhi Artha on 09/02/18.
//  Copyright © 2018 Sidhi Artha. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var record: AddressBookEntity!
    {
        didSet
        {
            bindToView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindToView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DetailViewController
{
    fileprivate func bindToView()
    {
        title = self.record?.name
        phoneLabel?.text = self.record?.phone
        descriptionLabel?.text = self.record?.desc
    }
}
