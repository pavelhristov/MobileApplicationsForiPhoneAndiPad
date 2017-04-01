//
//  loadingScreenExtension.swift
//  PizzaFactory
//
//  Created by pavelhristov on 4/1/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit

var loadingScreen = UIActivityIndicatorView()

extension UIViewController {
    func showLoadingScreen() {
        loadingScreen.frame = self.view.frame
        loadingScreen.activityIndicatorViewStyle = .whiteLarge
        loadingScreen.backgroundColor = .gray
        self.view.addSubview(loadingScreen)
        loadingScreen.startAnimating()
    }
    
    func hideLoadingScreen() {
        loadingScreen.stopAnimating()
        loadingScreen.removeFromSuperview()
    }
}
