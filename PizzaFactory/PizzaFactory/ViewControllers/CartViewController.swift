//
//  CartViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 4/2/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit
import SwiftLocation
import Toast_Swift

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HttpRequesterDelegate, UITextViewDelegate {
    var basePizzas: [BasePizza] = []
    var price:Float = 0
    
    @IBOutlet weak var TableViewPizzas: UITableView!
    @IBOutlet weak var TextViewAddress: UITextView!
    @IBOutlet weak var LabelPrice: UILabel!
    
    var http: HttpRequester?
    
    var baseUrl: String?
    
    var showCartUrl: String {
        get{
            return "\(self.baseUrl!)/pizzas/showcart"
        }
    }
    
    var confirmOrderUrl: String {
        get{
            let escapedString = self.TextViewAddress.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            return "\(self.baseUrl!)/pizzas/order?address=\(escapedString!)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.http?.delegate = self
        
        self.loadCart();
    }
    
    func loadCart(){
        self.showLoadingScreen()
        self.http?.get(fromUrl: self.showCartUrl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.TableViewPizzas.register(UITableViewCell.self, forCellReuseIdentifier: "base-pizza-cell")
        
        TableViewPizzas.delegate = self
        TableViewPizzas.dataSource = self
        
        self.TextViewAddress.delegate = self
        self.TextViewAddress.text = "Delivery Address"
        self.TextViewAddress.textColor = UIColor.lightGray
    }
    
    func didReceiveData(data: Any) {
        let dataArray = data as! [Dictionary<String, Any>]
        
        self.basePizzas = dataArray.map(){BasePizza(withDict: $0)}
        
        self.basePizzas.forEach { pizza in
            self.price += pizza.price
        }
        
        DispatchQueue.main.async {
            self.TableViewPizzas.reloadData()
            self.hideLoadingScreen()
            
            self.LabelPrice.text = NSString(format: "%.2f", self.price) as String
        }
    }
    
    func didReceiveMessage(success: Bool, message: String) {
        if (message.characters.count > 0) {
            DispatchQueue.main.async {
                self.hideLoadingScreen()
                self.view.makeToast(message)
                self.loadCart()
                self.price = 0
                self.TextViewAddress.text = nil
                self.textViewDidEndEditing(self.TextViewAddress)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.basePizzas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "base-pizza-cell", for: indexPath as IndexPath);
        cell.textLabel?.text = self.basePizzas[indexPath.row].name
        
        return cell
    }
    
    @IBAction func ButtonCurrentLocationClick() {
        self.showLoadingScreen()
        Location.getLocation(accuracy: .IPScan(IPService(.freeGeoIP)), frequency: .oneShot, success: { _,location in
            Location.getPlacemark(forLocation: location, success: { placemarks in
                let address = placemarks.first?.addressDictionary?["FormattedAddressLines"] as! [String]
                self.textViewDidBeginEditing(self.TextViewAddress)
                self.TextViewAddress.text = "\(address.joined(separator: ", "))"
                self.hideLoadingScreen()
            }) { error in
                print("Cannot get current address!")
                self.hideLoadingScreen()
            }
        }) { (_, last, error) in
            self.view.makeToast("Cannot get current address!")
            self.hideLoadingScreen()
        }
        
    }
    
    @IBAction func ButtonSendOrderClick() {
        if self.basePizzas.count > 0 {
            
            if (self.TextViewAddress.text.characters.count > 0 &&
                self.TextViewAddress.textColor != UIColor.lightGray){
                self.showLoadingScreen()
                self.http?.get(fromUrl: self.confirmOrderUrl)
            }else{
                self.view.makeToast("Address is required!")
            }
        }else{
            self.view.makeToast("There are no pizzas in the cart!")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Delivery Address"
            textView.textColor = UIColor.lightGray
        }
    }
}
