//
//  CustomPizzaListViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/30/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

class CustomPizzaListViewController: UITableViewController, HttpRequesterDelegate{
    var customPizzas: [CustomPizza] = []
    
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
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "custom-pizza-cell")
        
        self.http?.delegate = self
        
        self.http?.get(fromUrl: self.url)
    }
    
    
    func didReceiveData(data: Any) {
        let dataArray = data as! [Dictionary<String, Any>]
        
        self.customPizzas = dataArray.map(){CustomPizza(withDict: $0)}
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showDetails(of customPizza: CustomPizza){
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "custom-pizza-details") as! CustomPizzaDetailsViewController
        nextVC.customPizzaId = customPizza.id
        
        self.navigationController?.show(nextVC, sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customPizzas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom-pizza-cell", for: indexPath)
        cell.textLabel?.text = self.customPizzas[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetails(of: self.customPizzas[indexPath.row])
    }
}
