//
//  Users.swift
//  GitHubUsers
//
//  Created by atMamont on 22.07.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

// local storage for users
struct User {
    var login: String
    var html_url: String
    var avatar_url: String
}

// Using extension because of if we'll define this failable init in main struct, we should redefine all inits and we don't want to
extension User {
    init? (dict: JSONDictionary) {
        guard let login = dict["login"] as? String,
            html_url = dict["html_url"] as? String,
            avatar_url = dict["avatar_url"] as? String else {return nil}
        self.login = login
        self.html_url = html_url
        self.avatar_url = avatar_url
    }
}
