//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Guillermo Hernandez on 11/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client!.logout();
        self.dismiss(animated: true, completion: nil)
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTweets()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    
    func loadTweets() {
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: ["count": 10], success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        print(tweetArray[indexPath.row])
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Int)
        
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Int)
        
        
        
        return cell
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
