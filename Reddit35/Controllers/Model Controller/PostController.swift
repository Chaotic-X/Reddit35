//
//  PostController.swift
//  Reddit35
//
//  Created by Alex Lundquist on 8/5/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import Foundation
import class UIKit.UIImage

class PostController {
  //Hard coding our baseURL
  static let baseURL = URL(string: "https://www.reddit.com/r/")
  
  //Fetch Post
  static func fetchPost(forTopic searchString: String, completion: @escaping (Result<[Post], PostError>) -> Void) {
    guard let url = baseURL else { return completion(.failure(.invalidURL))}
    //ProgrammerHumor
    let finalURL = url.appendingPathComponent(searchString).appendingPathExtension(".json")
    //Do I need to do an http request?
    URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
      if let error = error {
        return completion(.failure(.thrownError(error)))
      }
      guard let data = data else { return completion(.failure(.noData))}
      do {
        //Decode data from Top Level Object (Dictionary)
        let topLevelDictionary = try JSONDecoder().decode(PostTopLevelObject.self, from: data)
        //Grab the Data and assign it to the "second level which is our "Post"
        let secondLevelDictionary = topLevelDictionary.data
        //Now we are taking that secondLevelDictionary "Post" and grabbing what we are looking for in it, the keyvalue of "Children"  Which is an array of "data"
        let thirdLevelArray = secondLevelDictionary.children
        //We need an empty array of type "Post" to start creating our "Post" objects from our data
        var arrayOfPosts: [Post] = []
        // **** See if you can do this in a "forEach" ****
        //Option Click "dict" to remind yourself what you are needing to go through to get your Data to create your Post objects and append that to your "Post" objects array
        for dict in thirdLevelArray {
          //we need to get the "data" out of that "ThirdLevelObject" so we can grab our Post Object data to append to the arrayOfPost
          let post = dict.data
          //appending that "post" data
          arrayOfPosts.append(post)
        }
        return completion(.success(arrayOfPosts))
      //End of Do of Do-Catch
      } catch {
        return completion(.failure(.thrownError(error)))
      } //End of Catch of Do-Catch
    }.resume() //End of URLSession SO FREAKING RESUME!
  } //End of FetchPost
  
  //Fetch Thumbnail
  static func fetchThumbnail(post: Post, completion: @escaping (Result<UIImage, PostError>) -> Void) {
    //Guard against the URL we are passing in incase what we get back from the Post data is a bad URL
    guard let thumbnailURL = URL(string: post.thumbnail) else { return completion(.failure(.invalidURL))}
    URLSession.shared.dataTask(with: thumbnailURL) { (data, _, error) in
      if let error = error {
        return completion(.failure(.thrownError(error)))
      }
      guard let data = data else { return completion(.failure(.noData))}
      guard let thumbnail = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
      return completion(.success(thumbnail))
    }.resume() //End of URLSession so RESUME!
  } //End of FetchThumbnail
} //End of Class
