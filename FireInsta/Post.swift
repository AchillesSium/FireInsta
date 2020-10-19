//
//  Post.swift
//  FireInsta
//
//  Created by Sium on 8/23/17.
//  Copyright © 2017 Refat. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    var author: String!
    var likes: Int!
    var pathToImage: String!
    var userID: String!
    var postID: String!
    
    var peopleWhoLikes: [String] = [String]()

}
