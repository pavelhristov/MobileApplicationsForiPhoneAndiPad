//
//  CustomPizzaDictionary.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/30/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import Foundation

extension CustomPizza{
    convenience init(withDict dict: Dictionary<String, Any>){
        let id = dict["Id"] as! String
        let name = dict["Name"] as! String
        let pizzaDescription = dict["Description"] as! String
        let ingredients = dict["Ingredients"] as! String
        let price = dict["Price"] as! Float
        self.init(withId :id, name: name, description: pizzaDescription,ingredients:ingredients,andPrice: price)
    }
    
    static func fromDict(_ dict: Dictionary<String, Any>) -> CustomPizza {
        return CustomPizza(withDict: dict)
    }
    
    func toDict() -> Dictionary<String, Any> {
        return [
            "Name": self.name,
            "Description": self.pizzaDescription,
            "Ingredients":self.ingredients,
            "Price":self.price
        ]
    }
}
