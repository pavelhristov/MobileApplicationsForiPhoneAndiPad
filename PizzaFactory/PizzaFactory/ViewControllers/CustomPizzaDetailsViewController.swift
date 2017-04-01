//
//  CustomPizzaDetailsViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/31/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

class CustomPizzaDetailsViewController: UIViewController, HttpRequesterDelegate{
    var customPizzaId: String?
    
    var customPizza: CustomPizza?
    
    var url: String {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return "\(appDelegate.baseUrl)/pizzas/custombyid/\(self.customPizzaId!)"
        }
    }
    
    var http: HttpRequester? {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.http
        }
    }
    
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelIngredients: UILabel!
    @IBOutlet weak var LabelDescription: UILabel!
    @IBOutlet weak var LabelPrice: UILabel!
    
    @IBAction func ButtonAddToCartClick() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.http?.delegate = self
        self.showLoadingScreen()
        self.http?.get(fromUrl: self.url)
    }
    
    override func viewDidLoad() {
        
    }
    
    func didReceiveData(data: Any) {
        let pizzaDictionary = data as! Dictionary<String, Any>
        self.customPizza = CustomPizza(withDict: pizzaDictionary)
        self.updateUI()
    }
    
    
    func updateUI() {
        DispatchQueue.main.async {
            self.LabelName.text = self.customPizza?.name
            self.LabelDescription.text = self.customPizza?.pizzaDescription
            self.LabelIngredients.text = self.customPizza?.ingredients
            self.LabelPrice.text = NSString(format: "%.2f", (self.customPizza?.price)!) as String
            
            self.hideLoadingScreen()
        }
    }
}
