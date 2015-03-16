//
//  User.swift
//  SwivlExam
//
//  Created by Sergiy Suprun on 3/15/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//



//"login": "jnewland",
//"id": 47,
//"avatar_url": "https://avatars.githubusercontent.com/u/47?v=3",
//"gravatar_id": "",
//"url": "https://api.github.com/users/jnewland",
//"html_url": "https://github.com/jnewland",
//"followers_url": "https://api.github.com/users/jnewland/followers",
//"following_url": "https://api.github.com/users/jnewland/following{/other_user}",
//"gists_url": "https://api.github.com/users/jnewland/gists{/gist_id}",
//"starred_url": "https://api.github.com/users/jnewland/starred{/owner}{/repo}",
//"subscriptions_url": "https://api.github.com/users/jnewland/subscriptions",
//"organizations_url": "https://api.github.com/users/jnewland/orgs",
//"repos_url": "https://api.github.com/users/jnewland/repos",
//"events_url": "https://api.github.com/users/jnewland/events{/privacy}",
//"received_events_url": "https://api.github.com/users/jnewland/received_events",
//"type": "User",
//"site_admin": true

import Foundation

class User : NSObject, MappableObject{
    var userId:Int = 0
    var login = ""
    var avatarUrl = ""
    var htmlUrl = ""

    
    override required init() {
        super.init()
    }
    
    class func fromJSONMappingSheme() -> [String:String] {
    
        return [
            "id": "userId",
            "login": "login",
            "avatar_url": "avatarUrl",
            "html_url": "htmlUrl",
        ]
    }

}