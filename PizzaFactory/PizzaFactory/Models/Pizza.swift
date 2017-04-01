//
//  Pizza.swift
//  PizzaFactory
//
//  Created by pavelhristov on 4/1/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import Foundation

class Pizza{
    var id : String
    var name: String
    var pizzaDescription: String
    var imgUrl: String
    var price: Float
    
    convenience init(withTitle name: String, description pizzaDescription: String, imgUrl: String, andPrice price:Float){
        self.init(withId: "", name: name, description: pizzaDescription,imgUrl:imgUrl,andPrice: price)
    }
    
    init(withId id: String, name: String, description pizzaDescription: String, imgUrl: String, andPrice price:Float){
        self.id = id
        self.name = name
        self.pizzaDescription = pizzaDescription
        self.imgUrl = imgUrl
        self.price = price
    }
}
