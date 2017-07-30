//
//  UserListViewController.swift
//  Finder
//
//  Created by Tyler Holloway on 7/30/17.
//  Copyright © 2017 Finder. All rights reserved.
//

import UIKit
import Parse


class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var myTable: UITableView!
    
    // Empty Array of Parse users
    var users = [PFUser]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        let userObject: PFUser = users[indexPath.row]
        userCell.textLabel!.text = userObject.object(forKey: "username") as? String
        
        return userCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped row: \(indexPath.row)")
    }
    
    
    
    func loadUsers() {
        let userQuery = PFQuery(className: "_User")
        userQuery.findObjectsInBackground { (result: [PFObject]?, error) in
            
            if let foundUsers = result as? [PFUser] {
                self.users = foundUsers
                self.myTable.reloadData()
            }
        }
    }
    
    

}
