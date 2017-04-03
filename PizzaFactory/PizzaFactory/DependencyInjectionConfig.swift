//
//  DependencyInjectionConfig.swift
//  PizzaFactory
//
//  Created by pavelhristov on 4/2/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import Swinject
import SwinjectStoryboard

class DiConfigHttp {
    public static func setup(container: Container){
        container.register(HttpRequester.self){_ in HttpRequester() }
    }
}

var baseUrl: String = "http://192.168.0.101/api"

class DiConfigControllers {
    public static func setup(container: Container){
        container.storyboardInitCompleted(HomeViewController.self) {r, c in
        }
        
        container.storyboardInitCompleted(PizzaListViewController.self) {r, c in
            let http = r.resolve(HttpRequester.self)
            http?.delegate = c
            c.http = http
            
            let url = "\(baseUrl)/pizzas/ours"
            c.url = url
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            c.appDelegate = appDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            c.managedObjectContext = context
        }
        
        container.storyboardInitCompleted(CustomPizzaDetailsViewController.self) {r, c in
            let http = r.resolve(HttpRequester.self)
            http?.delegate = c
            c.http = http
            
            let url = baseUrl
            c.baseUrl = url
        }
        
        container.storyboardInitCompleted(PizzaDetailsViewController.self) {r, c in
            let http = r.resolve(HttpRequester.self)
            http?.delegate = c
            c.http = http
            
            let url = baseUrl
            c.baseUrl = url
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            c.appDelegate = appDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            c.managedObjectContext = context
        }
        
        container.storyboardInitCompleted(CustomPizzaListViewController.self) {r, c in
            let http = r.resolve(HttpRequester.self)
            http?.delegate = c
            c.http = http
            
            let url = "\(baseUrl)/pizzas/custom"
            c.url = url
        }
        
        container.storyboardInitCompleted(CartViewController.self) {r, c in
            let http = r.resolve(HttpRequester.self)
            http?.delegate = c
            c.http = http
            
            let url = baseUrl
            c.baseUrl = url
        }
    }
}

extension SwinjectStoryboard {
    public static func setup() {
        DiConfigHttp.setup(container: defaultContainer)
        DiConfigControllers.setup(container: defaultContainer)
    }
}
