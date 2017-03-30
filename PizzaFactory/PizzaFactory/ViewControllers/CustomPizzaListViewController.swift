//
//  CustomPizzaListViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/30/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

class CustomPizzaListViewController: UITableViewController, HttpRequesterDelegate{
    var customPizzas: [String] = ["pizza1","pizza2","pizza3"]
    
    var url: String {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return "\(appDelegate.baseUrl)/pizzas/custom"
        }
    }
    
    var http: HttpRequester? {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.http
        }
    }
    
    override func viewDidLoad() {
        print("Custom pizzas")
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "custom-pizza-cell")
        
        self.http?.delegate = self
        
        self.http?.get(fromUrl: self.url)
    }
    
    
    func didReceiveData(data: Any) {
        let dataArray = data as! [Dictionary<String, Any>]
        
        self.customPizzas = dataArray.map(){CustomPizza(withDict: $0).name}
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
