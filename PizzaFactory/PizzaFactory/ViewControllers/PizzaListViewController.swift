//
//  PizzaListViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/29/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit
import CoreData

class PizzaListViewController: UITableViewController, HttpRequesterDelegate{
    var Pizzas: [Pizza] = []
    
    @IBOutlet var pizzaListView: UIView!
    
    var appDelegate: AppDelegate?
    
    var managedObjectContext: NSManagedObjectContext?
    
    var url: String?
    
    var http: HttpRequester?
    
    override func viewWillAppear(_ animated: Bool) {
        /*
         // clear PizzaImage "cache"
         let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PizzaImage")
         let request = NSBatchDeleteRequest(fetchRequest: fetch)
         
         do{
         try self.managedObjectContext.execute(request)
         }catch{
         print("error clearing cache")
         }
         */
        self.http?.delegate = self
        
        self.showLoadingScreen()
        self.http?.get(fromUrl: self.url!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "PizzaTableViewCell", bundle: nil)
        
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
    
    func showDetails(of pizza: Pizza){
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pizza-details") as! PizzaDetailsViewController
        nextVC.pizzaId = pizza.id
        
        self.navigationController?.show(nextVC, sender: self)
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
        
        
        do {
            let myRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PizzaImage")
            myRequest.predicate = NSPredicate(format: "imgUrl = %@", pizza.imgUrl)
            let imgData = try self.managedObjectContext?.fetch(myRequest).first as? PizzaImage
            let image: UIImage
            if imgData == nil {
                // if no image is found, cache it
                let pizzaImage:PizzaImage = PizzaImage(entity: NSEntityDescription.entity(forEntityName: "PizzaImage", in: self.managedObjectContext!)!, insertInto: self.managedObjectContext)
                
                pizzaImage.imgUrl = pizza.imgUrl
                let imageData = try Data(contentsOf: URL(string: pizza.imgUrl)!)
                image = UIImage(data: imageData)!
                pizzaImage.imgData = imageData as NSData?
                
                self.managedObjectContext?.insert(pizzaImage)
                
                self.appDelegate?.saveContext()
            } else {
                // using cached images
                image = UIImage(data: imgData?.imgData as! Data)!
            }
            
            cell.ImageViewPicture.image = image
            
            
        } catch let error as NSError {
            print("The error is \(error.userInfo)")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetails(of: self.Pizzas[indexPath.row])
    }
    
}
