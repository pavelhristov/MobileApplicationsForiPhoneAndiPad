//
//  CustomPizza.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/30/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import Foundation

class CustomPizza{
    var id : String
    var name: String
    var pizzaDescription: String
    var ingredients: String
    var price: Float
    
    convenience init(withTitle name: String, description pizzaDescription: String, ingredients: String, andPrice price:Float){
        self.init(withId: "", name: name, description: pizzaDescription,ingredients:ingredients,andPrice: price)
    }
    
    init(withId id: String, name: String, description pizzaDescription: String, ingredients: String, andPrice price:Float){
        self.id = id
        self.name = name
        self.pizzaDescription = pizzaDescription
        self.ingredients = ingredients
        self.price = price
    }
}
