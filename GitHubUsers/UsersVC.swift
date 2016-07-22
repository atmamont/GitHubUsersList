//
//  ViewController.swift
//  GitHubUsers
//
//  Created by atMamont on 22.07.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit


class UserCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    var user: User?
    
    func configure(){
        guard let user = user else {return}
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 15
        
        avatarImageView.downloadImageFrom(link: user.avatar_url, contentMode: .ScaleAspectFit)
        loginLabel.text = user.login
        urlLabel.text = user.html_url
    }
}

class UsersVC: UITableViewController {

    var users = [User]()
    var sinceIndex = 0
    static let USERS_PER_PAGE = 50 // fetching in one request
   
    // helper to create URL with pagination
    func createUsersResource(since: Int) -> Resource<[User]>{
        let usersURL = NSURL(string: apiURL + "users?per_page="+String(UsersVC.USERS_PER_PAGE)+"&since="+String(since))!
        
        let batchUsersResource = Resource<[User]>(url: usersURL) { json  in
            guard let usersDict = json as? [JSONDictionary] else {return nil}
            return usersDict.flatMap(User.init)
        }
        
        return batchUsersResource
        
    }
    
    //MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        

        // basic pagination, loading portions of 50 users
        // no check if there are any left on server (assuming it is impossible to scroll down all github users :)
        // next request when scrolled to last loaded cell
        
        WebService().load(createUsersResource(sinceIndex)) { result in
            guard let users = result else {return}
            self.users = users
            print(self.users)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            
        }
        
    }

    //MARK: TableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UserCell
        
        cell.user = users[indexPath.row]
        cell.configure()
        
        // checking if it is time load more users
        
        if (indexPath.row == users.count - 1){
            sinceIndex += 50
            WebService().load(createUsersResource(sinceIndex)) { result in
                guard let users = result else {return}
                self.users += users
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
        return cell
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showFollowers" && sender is UserCell) {
            let followersVC = segue.destinationViewController as? FollowersVC
            
            let selectedIndexPath = self.tableView.indexPathForCell(sender as! UserCell)
            
            followersVC?.selectedUser = users[selectedIndexPath!.row]
        }
    }

}

