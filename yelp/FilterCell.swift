//
//  FilterCell.swift
//  yelp
//
//  Created by Sid Reddy on 9/22/14.
//  Copyright (c) 2014 Sid Reddy. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {


    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var stateSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
