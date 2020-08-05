//
//  Post.swift
//  Reddit35
//
//  Created by Alex Lundquist on 8/5/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import Foundation

struct PostTopLevelObject: Decodable {
  let data: PostSecondLevelObject
}
struct PostSecondLevelObject: Decodable {
  let children: [PostThirdLevelObject]
}
struct PostThirdLevelObject: Decodable {
  let data: Post
}
struct Post: Decodable {
  let title: String
  let ups: Int
  let thumbnail: String
}
