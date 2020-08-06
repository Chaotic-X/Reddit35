//
//  PostListTableViewController.swift
//  Reddit35
//
//  Created by Alex Lundquist on 8/5/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
   // ************* Add a Search Bar **************
  //MARK: -Properties
  var posts: [Post] = []
  
  //MARK: -LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    PostController.fetchPost(forTopic: "ProgrammerHumor") { (result) in
      DispatchQueue.main.async {
        switch result {
          case .success(let posts):
            self.posts = posts
            self.tableView.reloadData()
          case .failure(let error):
          print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
      }
    }
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return posts.count
  } //End of Number of Rows
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
    
    let post = self.posts[indexPath.row]
    cell.postCellTitleLabel.text = post.title
    cell.postUPSLabel.text = "ups: \(post.ups) ⬆️"
    cell.postCellImageView.image = UIImage(named: "noimage")
    PostController.fetchThumbnail(post: post) { (result) in
      DispatchQueue.main.async {
        switch result {
          case .success(let thumbnail):
            cell.postCellImageView.image = thumbnail
            print("We got our image YAY")
          case .failure(let error):
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            //default image if image couldn't load
            cell.postCellImageView.image = UIImage(named: "noimage")
        } //End of Switch
      } //End of DispatchQueue
    } //End of FetchThumbnail
    return cell
  } //End of tableViewCell
} //End of PostListTableViewController

//MARK: -Extensions


