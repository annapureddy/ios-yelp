//
//  FilterViewController.swift
//  yelp
//
//  Created by Sid Reddy on 9/22/14.
//  Copyright (c) 2014 Sid Reddy. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [String] = ["active", "amateursportsteams", "amusementparks", "aquariums", "archery", "beaches", "bikerentals", "boating", "bowling", "climbing", "diving", "freediving", "scuba", "fencing", "fishing", "fitness", "dancestudio", "gyms", "martialarts", "pilates", "swimminglessons", "taichi", "healthtrainers"]
    var categoriesSelected: [Bool] = []
    var categoriesSelectedTmp: [Bool] = []
    var categoriesExpanded: Bool = false
    
    var sortby: [String] = ["Best match", "Distance", "Highest rated"]
    var sortbySelected: [Bool] = []
    var sortbySelectedTmp: [Bool] = []
    
    var distance: [String] = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    var distanceSelected: [Bool] = []
    var distanceSelectedTmp: [Bool] = []
    var distanceExpanded: Bool = false
    var distanceIndexSelected: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize arrays to store user selections 
        categoriesSelected = [Bool](count: self.categories.count, repeatedValue: false)
        categoriesSelected[0] = true
        categoriesSelectedTmp = categoriesSelected
        
        sortbySelected = [Bool](count: self.sortby.count, repeatedValue: false)
        sortbySelected[0] = true
        sortbySelectedTmp = sortbySelected
        
        distanceSelected = [Bool](count: self.distance.count, repeatedValue: false)
        distanceSelected[0] = true
        distanceSelectedTmp = distanceSelected

        // Take control of the table view
        tableView.delegate = self
        tableView.dataSource = self
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

    @IBAction func switchStateChanged(sender: UISwitch!) {
        var section: Int! = sender.tag / 100
        var row: Int! = sender.tag % 100
        switch(section) {
        case 0:
            categoriesSelectedTmp[row] = true
            return
        case 1:
            sortbySelectedTmp[row] = true
            return
        case 2:
            distanceSelectedTmp[row] = true
            return
        default:
            return
        }
    }
    
    @IBAction func dismissFilterViewController(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAndDismissFilterViewController(sender: UIBarButtonItem) {
        categoriesSelected = categoriesSelectedTmp
        sortbySelected = sortbySelectedTmp
        distanceSelected = distanceSelectedTmp
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension FilterViewController: UITableViewDelegate {
    
}

extension FilterViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return (categoriesExpanded ? categories.count : 3) + 1
        case 1:
            return sortby.count
        case 2:
            return distanceExpanded ? distance.count : 1
        case 3:
            return 1
        default:
            return 15
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        var cell = tableView.dequeueReusableCellWithIdentifier("filterCell") as FilterCell
        cell.stateSwitch.hidden = false
        
        switch(indexPath.section) {
        case 0:
            if (indexPath.row < categories.count) {
                if (categoriesExpanded || indexPath.row < 3) {
                    cell.optionLabel.text = categories[indexPath.row]
                }
                else if (indexPath.row == 3) {
                    cell.optionLabel.text = "See More"
                    cell.stateSwitch.hidden = true
                }
            }
            else {
                cell.optionLabel.text = "See Less"
                cell.stateSwitch.hidden = true
            }
            break
        case 1:
            cell.optionLabel.text = sortby[indexPath.row]
            break
        case 2:
            cell.optionLabel.text = distanceExpanded ? distance[indexPath.row] : distance[distanceIndexSelected]
            cell.stateSwitch.hidden = true
            break
        case 3:
            cell.optionLabel.text = "Deals"
            break
        default:
            break
        }
        
        cell.stateSwitch.tag = indexPath.section * 100 + indexPath.row
        cell.stateSwitch.addTarget(self, action: "switchStateChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Category"
        case 1:
            return "Sort by"
        case 2:
            return "Distance"
        case 3:
            return "Businesses with deals"
        default:
            return "Hello! This case should not arise"
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            if (categoriesExpanded && indexPath.row == categories.count) {
                categoriesExpanded = false
                tableView.reloadData()
            }
            else if (!categoriesExpanded && indexPath.row == 3) {
                categoriesExpanded = true
                tableView.reloadData()
            }
        }
        else if (indexPath.section == 2) {
            distanceExpanded = !distanceExpanded
            distanceIndexSelected = indexPath.row
            tableView.reloadData()
        }
    }
}
