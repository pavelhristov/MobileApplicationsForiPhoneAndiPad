//
//  CustomPizzaTableViewCell.swift
//  PizzaFactory
//
//  Created by pavelhristov on 4/2/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

class CustomPizzaTableViewCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override var textLabel: UILabel? {
        get {
            return self.nameLabel
        }
        set(textLabel) {
            self.nameLabel = textLabel
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.nameLabel.font = UIFont(name: "Chalkduster", size: 20)
        self.priceLabel.font = UIFont(name: "Cochin-Italic", size: 15)
    }
}
