//
//  DriverTableViewController.swift
//  Uber-clone
//
//  Created by Tanin on 01/12/2017.
//  Copyright © 2017 landtanin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DriverTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }

}
