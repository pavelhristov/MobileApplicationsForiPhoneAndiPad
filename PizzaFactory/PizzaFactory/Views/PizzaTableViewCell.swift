//
//  PizzaTableViewCell.swift
//  PizzaFactory
//
//  Created by pavelhristov on 4/1/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

class PizzaTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageViewPicture: UIImageView!
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.ImageViewPicture.layer.masksToBounds = true
        self.ImageViewPicture.layer.cornerRadius = 10
        
        self.LabelName.font = UIFont(name: "MarkerFelt-Thin", size: 20)
        self.LabelPrice.font = UIFont(name: "Palatino-Italic", size: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
