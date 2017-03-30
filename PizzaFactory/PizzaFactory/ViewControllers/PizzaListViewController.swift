//
//  PizzaListViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/29/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

class PizzaListViewController: UIViewController{
    @IBOutlet var pizzaListView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.view = pizzaListView
    }
    override func viewDidLoad() {
        print("Hello!")
    }
    
}
