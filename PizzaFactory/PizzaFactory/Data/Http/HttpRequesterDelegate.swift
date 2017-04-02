//
//  HttpRequesterDelegate.swift
//  PizzaFactory
//
//  Created by pavelhristov on 3/30/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

protocol HttpRequesterDelegate {
    func didReceiveData(data: Any)
    func didReceiveMessage(success:Bool , message: String)
    func didReceiveError(error: String)
}

extension HttpRequesterDelegate {
    func didReceiveData(data: Any) {
        
    }
    
    func didReceiveError(error: String) {
        
    }
    
    func didReceiveMessage(success: Bool, message: String){
        
    }
}
