//
//  PizzaListViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/29/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

class PizzaListViewController: UITableViewController, HttpRequesterDelegate{
    var Pizzas: [Pizza] = []
    
    @IBOutlet var pizzaListView: UIView!
    
    var url: String {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return "\(appDelegate.baseUrl)/pizzas/ours"
        }
    }
    
    var http: HttpRequester? {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.http
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.http?.delegate = self
        
        self.showLoadingScreen()
        self.http?.get(fromUrl: self.url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "PizzaTableViewCell", bundle: nil)
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "pizza-cell")
        self.tableView.register(cellNib, forCellReuseIdentifier: "pizza-cell")
        self.tableView.rowHeight = 100
    }
    
    
    func didReceiveData(data: Any) {
        let dataArray = data as! [Dictionary<String, Any>]
        
        self.Pizzas = dataArray.map(){Pizza(withDict: $0)}
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.hideLoadingScreen()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Pizzas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pizza-cell", for: indexPath) as! PizzaTableViewCell
        let pizza = self.Pizzas[indexPath.row]
        cell.LabelName.text = pizza.name
        cell.LabelPrice.text = NSString(format: "%.2f", (pizza.price)) as String
        
        do{
            let imageData = try Data(contentsOf: URL(string: pizza.imgUrl)!)
            let image = UIImage(data: imageData)
            cell.ImageViewPicture.image = image
        } catch {
            
        }
        return cell
    }
    
    
}
