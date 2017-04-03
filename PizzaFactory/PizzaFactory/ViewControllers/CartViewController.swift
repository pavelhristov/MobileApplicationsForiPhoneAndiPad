//
//  CartViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 4/2/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit
import SwiftLocation

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HttpRequesterDelegate {
    var basePizzas: [BasePizza] = []
    var price:Float = 0

    @IBOutlet weak var TableViewPizzas: UITableView!
    @IBOutlet weak var TextViewAddress: UITextView!
    @IBOutlet weak var LabelPrice: UILabel!
    
    
    
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var showCartUrl: String {
        get{
            return "\(self.appDelegate.baseUrl)/pizzas/showcart"
        }
    }
    
    var confirmOrderUrl: String {
        get{
            return "\(self.appDelegate.baseUrl)/pizzas/order?address=\(self.TextViewAddress.text)"
        }
    }
    
    var http: HttpRequester? {
        get{
            return self.appDelegate.http
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.http?.delegate = self
        
        self.showLoadingScreen()
        self.http?.get(fromUrl: self.showCartUrl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.TableViewPizzas.register(UITableViewCell.self, forCellReuseIdentifier: "base-pizza-cell")
        
        TableViewPizzas.delegate = self
        TableViewPizzas.dataSource = self
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
        
        Location.getLocation(accuracy: .IPScan(IPService(.freeGeoIP)), frequency: .oneShot, success: { _,location in
            Location.getPlacemark(forLocation: location, success: { placemarks in
                let address = placemarks.first?.addressDictionary?["FormattedAddressLines"] as! [String]
                self.TextViewAddress.text = "\(address.joined(separator: ", "))"
            }) { error in
                print("Cannot retrive placemark due to an error \(error)")
            }
        }) { (_, last, error) in
            print("Something bad has occurred \(error)")
        }
        
    }
    
    @IBAction func ButtonSendOrderClick() {
    }
}
