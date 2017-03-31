//
//  CustomPizzaDetailsViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/31/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

class CustomPizzaDetailsViewController: UIViewController{
    var customPizzaId: String = ""
    
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelIngredients: UILabel!
    @IBOutlet weak var LabelDescription: UILabel!
    @IBOutlet weak var LabelPrice: UILabel!
    
    @IBAction func ButtonAddToCartClick() {
    }
    
    
    override func viewDidLoad() {
        print(self.customPizzaId)
    }
}
