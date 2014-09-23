//
//  YelpSearchViewController.swift
//  yelp
//
//  Created by Sid Reddy on 9/21/14.
//  Copyright (c) 2014 Sid Reddy. All rights reserved.
//

import UIKit

class YelpSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var client: YelpClient!
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    var businesses: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Take control of tableView
        tableView.delegate = self
        tableView.dataSource = self

        // Position search bar in navigation bar
        self.navigationItem.titleView = searchBar
        
        getYelpResults()
    }
    
    func getYelpResults() {
        // Call YelpClient to get results
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        client.searchWithTerm("Thai",
            success:
            { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var yelpInfo = response as NSDictionary!
                self.businesses = yelpInfo.objectForKey("businesses") as [NSDictionary]
                self.tableView.reloadData()
            },
            failure:
            { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension YelpSearchViewController: UITableViewDelegate {
    
}

extension YelpSearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("yelpCell") as YelpCell
        
        var business = businesses[indexPath.row] as NSDictionary
        var posterImageURL = business["image_url"] as String!
        cell.posterImage.setImageWithURL(NSURL(string: posterImageURL))
        cell.nameLabel.text = business["name"] as String!
        cell.distanceLabel.text = "0.5 mi"
        cell.priceLabel.text = "$$"
        var ratingImageURL = business["rating_img_url_small"] as String
        cell.ratingImage.setImageWithURL(NSURL(string: ratingImageURL))
        var reviews = business["review_count"] as Int!
        cell.reviewsLabel.text = "\(reviews) Reviews"
        var location = business["location"] as NSDictionary
        var address = location["address"] as [String]!
        cell.addressLabel.text = address[0]
        
        return cell
    }
}
