//
//  HomeViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/28/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController{
    @IBOutlet weak var LabelTitle: UILabel!
    
    override func viewDidLoad() {
        self.LabelTitle.text = "Hello"
    }
}
