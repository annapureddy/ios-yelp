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
    
    let CATEGORIES: [String] = ["active", "amateursportsteams", "amusementparks", "aquariums", "archery", "beaches", "bikerentals", "boating", "bowling", "climbing", "diving", "freediving", "scuba", "fencing", "fishing", "fitness", "dancestudio", "gyms", "martialarts", "pilates", "swimminglessons", "taichi", "healthtrainers"]
    var categoriesSelected: [Bool] = []
    var categoriesSelectedTmp: [Bool] = []
    var categoriesExpanded: Bool = false
    
    let SORTBY: [String] = ["Best match", "Distance", "Highest rated"]
    var sortbySelected: Int = 0
    var sortbySelectedTmp: Int = 0
    
    let DISTANCE: [String] = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    var distanceExpanded: Bool = false
    var distanceIndexSelected: Int = 0
    
    var deals: Bool = false
    
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize arrays
        categoriesSelected = [Bool](count: self.CATEGORIES.count, repeatedValue: false)
        
        // Take control of the table view
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Initialize arrays to reflect user selections
        var categories: String? = defaults.stringForKey("categories")
        categories = categories != nil ? categories : "active"
        for i in 0...CATEGORIES.count - 1 {
            if (categories!.rangeOfString(CATEGORIES[i]) != nil) {
                categoriesSelected[i] = true
            }
        }
        categoriesSelectedTmp = categoriesSelected

        sortbySelected = defaults.integerForKey("sortby")
        sortbySelectedTmp = sortbySelected
        
        var distanceSelected = defaults.integerForKey("radius")
        switch(distanceSelected) {
        case 0:
            distanceIndexSelected = 0
            break
        case 1000:
            distanceIndexSelected = 0
            break
        case 480:
            distanceIndexSelected = 1
            break
        case 1600:
            distanceIndexSelected = 2
            break
        case 8000:
            distanceIndexSelected = 3
            break
        case 32000:
            distanceIndexSelected = 4
            break
        default:
            distanceIndexSelected = -1
            break
        }
        
        deals = defaults.boolForKey("deals")
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
            categoriesSelectedTmp[row] = sender.on
            return
        case 1:
            sortbySelectedTmp = row
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
            return
        case 3:
            deals = sender.on
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
        var categories: String = ""
        for i in 0...CATEGORIES.count - 1 {
            categories += categoriesSelected[i] == true ? CATEGORIES[i] + "," : ""
        }
        categories.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: ","))
        defaults.setValue(categories != "" ? categories : "active", forKey: "categories")
        
        sortbySelected = sortbySelectedTmp
        defaults.setInteger(sortbySelected, forKey: "sortby")
        
        var distanceSelected = 1000
        switch(distanceIndexSelected) {
        case 0:
            distanceSelected = 1000
            break
        case 1:
            distanceSelected = 480
            break
        case 2:
            distanceSelected = 1600
            break
        case 3:
            distanceSelected = 8000
            break
        case 4:
            distanceSelected = 32000
            break
        default:
            distanceSelected = 1000
        }
        defaults.setInteger(distanceSelected, forKey: "radius")
        
        defaults.setBool(deals, forKey: "deals")

        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension FilterViewController: UITableViewDelegate {
    
}

extension FilterViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return (categoriesExpanded ? CATEGORIES.count : 3) + 1
        case 1:
            return SORTBY.count
        case 2:
            return distanceExpanded ? DISTANCE.count : 1
        case 3:
            return 1
        default:
            return 15
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        var cell = tableView.dequeueReusableCellWithIdentifier("filterCell") as FilterCell
        cell.stateSwitch.hidden = false
        cell.stateSwitch.on = false
        
        switch(indexPath.section) {
        case 0:
            if (indexPath.row < CATEGORIES.count) {
                if (categoriesExpanded || indexPath.row < 3) {
                    cell.optionLabel.text = CATEGORIES[indexPath.row]
                    cell.stateSwitch.on = categoriesSelectedTmp[indexPath.row]
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
            cell.optionLabel.text = SORTBY[indexPath.row]
            cell.stateSwitch.on = indexPath.row == sortbySelectedTmp ? true : false
            break
        case 2:
            cell.optionLabel.text = distanceExpanded ? DISTANCE[indexPath.row] : DISTANCE[distanceIndexSelected]
            cell.stateSwitch.hidden = true
            break
        case 3:
            cell.optionLabel.text = "Deals"
            cell.stateSwitch.on = deals
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
            if (categoriesExpanded && indexPath.row == CATEGORIES.count) {
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
