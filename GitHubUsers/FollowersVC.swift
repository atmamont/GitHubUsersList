//
//  FollowersVC.swift
//  GitHubUsers
//
//  Created by atMamont on 22.07.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class FollowerCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    var user: User?
    
    func configure(){
        guard let user = user else {return}
        
        avatarImageView.downloadImageFrom(link: user.avatar_url, contentMode: .ScaleAspectFit)
        loginLabel.text = user.login
        urlLabel.text = user.html_url
    }
}

class FollowersVC: UITableViewController {

    var selectedUser: User!
    var followers = [User]()
    
    @IBOutlet weak var titleNavBar: UINavigationItem!
    
    override func viewDidLoad() {
        
        titleNavBar.title = selectedUser.login
        tableView.allowsSelection = false
        
        let followersURL = NSURL(string: apiURL+"users/"+selectedUser.login+"/followers")
        let followersResource = Resource<[User]>(url: followersURL!, parseJSON: { json in
            guard let followersDict = json as? [JSONDictionary] else {return nil}
            return followersDict.flatMap(User.init)
        })
        
        WebService().load(followersResource) { result in
            guard let result = result else {return}
            self.followers = result
            print(self.followers)
            
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
        return followers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("followerCell", forIndexPath: indexPath) as! FollowerCell
        
        cell.user = followers[indexPath.row]
        cell.configure()
        
        return cell
    }
    
    
}
