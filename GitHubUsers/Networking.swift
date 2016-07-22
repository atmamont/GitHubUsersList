//
//  Networking.swift
//  GitHubUsers
//
//  Created by atMamont on 22.07.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import Foundation

let apiURL = "https://api.github.com/"

// abstract network resource

struct Resource<A> {
    let url: NSURL
    let parse: NSData -> A? // optional if parsing fails
}

extension Resource {
    init(url: NSURL, parseJSON: AnyObject -> A?) {
        self.url = url
        self.parse = { data in
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            // using flatMap to avoid nil, business login may vary of course
            return json.flatMap(parseJSON)
        }
    }
}


// Defining exact github api resources

final class WebService{
    // just making network request then passing result to resource.parse()
    func load<A>(resource: Resource<A>, completion: (A?) -> ()) {
        NSURLSession.sharedSession().dataTaskWithURL(resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data)) // just convenient for reading code
            
            }.resume()
    }
}

