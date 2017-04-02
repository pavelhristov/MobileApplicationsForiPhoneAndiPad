//
//  BasePizza.swift
//  PizzaFactory
//
//  Created by pavelhristov on 4/2/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import Foundation

class BasePizza{
    var id : String
    var name: String
    var price: Float
    
    convenience init(withTitle name: String, andPrice price:Float){
        self.init(withId: "", name: name, andPrice: price)
    }
    
    init(withId id: String, name: String, andPrice price:Float){
        self.id = id
        self.name = name
        self.price = price
    }
}
