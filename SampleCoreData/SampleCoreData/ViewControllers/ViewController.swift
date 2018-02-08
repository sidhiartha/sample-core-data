//
//  ViewController.swift
//  SampleCoreData
//
//  Created by Sidhi Artha on 03/02/18.
//  Copyright © 2018 Sidhi Artha. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var records = [AddressBookEntity]()
    {
        didSet
        {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        records = CoreDataManager.shared.loadAll(entityName: "AddressBookEntity") as! [AddressBookEntity]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"
        {
            let controller = segue.destination as? DetailViewController
            controller?.record = sender as? AddressBookEntity
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        let record = records[indexPath.row]
        cell.textLabel?.text = record.name ?? record.phone
        cell.detailTextLabel?.text = record.phone
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: records[indexPath.row])
    }
}

