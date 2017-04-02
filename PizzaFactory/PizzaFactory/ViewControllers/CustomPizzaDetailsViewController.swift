//
//  CustomPizzaDetailsViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/31/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit
import Toast_Swift

class CustomPizzaDetailsViewController: UIViewController, HttpRequesterDelegate{
    var customPizzaId: String?
    
    var customPizza: CustomPizza?
    
    
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var url: String {
        get{
            return "\(self.appDelegate.baseUrl)/pizzas/custombyid/\(self.customPizzaId!)"
        }
    }
    
    var addToCartUrl: String{
        get{
            return "\(self.appDelegate.baseUrl)/pizzas/addtocart?pizzaId=\(self.customPizzaId!)"
        }
    }
    
    var http: HttpRequester? {
        get{
            return self.appDelegate.http
        }
    }
    
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelIngredients: UILabel!
    @IBOutlet weak var LabelDescription: UILabel!
    @IBOutlet weak var LabelPrice: UILabel!
    
    @IBAction func ButtonAddToCartClick() {
        self.showLoadingScreen()
        self.http?.get(fromUrl: self.addToCartUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.http?.delegate = self
        self.showLoadingScreen()
        self.http?.get(fromUrl: self.url)
        
        self.LabelName.font = UIFont(name: "Chalkduster", size: 30)
        self.LabelIngredients.font = UIFont(name:"TimesNewRomanPS-ItalicMT",size:20)
        self.LabelDescription.font = UIFont(name:"TimesNewRomanPS-ItalicMT",size:20)
        self.LabelPrice.font = UIFont(name: "Cochin-Italic", size: 15)
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
    
    func didReceiveMessage(success: Bool, message: String) {
        if (message.characters.count > 0) {
            DispatchQueue.main.async {
                self.hideLoadingScreen()
                self.view.makeToast(message)
            }
        }
    }
}
