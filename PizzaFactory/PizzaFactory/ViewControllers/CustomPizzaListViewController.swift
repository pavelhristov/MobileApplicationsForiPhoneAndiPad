//
//  CustomPizzaListViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/30/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

class CustomPizzaListViewController: UITableViewController{
    var customPizzas: [String] = ["pizza1","pizza2","pizza3"]
    
    override func viewDidLoad() {
        print("Custom pizzas")
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "custom-pizza-cell")
        
        //self.navigationItem.rightBarButtonItem =
         //   UIBarButtonItem(barButtonSystemItem: .add,
          //                  target: self,
          //                  action: #selector(CustomPizzaListViewController.showAddModal))
        //self.loadBooks()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customPizzas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom-pizza-cell", for: indexPath)
        cell.textLabel?.text = self.customPizzas[indexPath.row]
        
        return cell
    }
}
