//
//  PizzaDetailsViewController.swift
//  PizzaFactory
//
//  Created by pavelhristov on 4/2/17.
//  Copyright © 2017 pavelhristov. All rights reserved.
//

import UIKit
import CoreData

class PizzaDetailsViewController: UIViewController, HttpRequesterDelegate{
    @IBOutlet weak var ImageViewPicture: UIImageView!
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelDescription: UILabel!
    @IBOutlet weak var LabelPrice: UILabel!
    
    var pizzaId: String?
    
    var pizza: Pizza?
    
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        get {
            return self.appDelegate.persistentContainer.viewContext
        }
    }
    
    
    var url: String {
        get{
            return "\(self.appDelegate.baseUrl)/pizzas/oursbyid/\(self.pizzaId!)"
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
        self.http?.get(fromUrl: self.url)
        
        self.LabelName.font = UIFont(name: "MarkerFelt-Thin", size: 30)
        self.LabelDescription.font = UIFont(name:"TimesNewRomanPS-ItalicMT",size:20)
        self.LabelPrice.font = UIFont(name: "Palatino-Italic", size: 15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func didReceiveData(data: Any) {
        let pizzaDictionary = data as! Dictionary<String, Any>
        self.pizza = Pizza(withDict: pizzaDictionary)
        self.updateUI()
    }
    
    
    func updateUI() {
        DispatchQueue.main.async {
            self.LabelName.text = self.pizza?.name
            self.LabelDescription.text = self.pizza?.pizzaDescription
            self.LabelPrice.text = NSString(format: "%.2f", (self.pizza?.price)!) as String
            
            // TODO: remove duplicating code
            do {
                let myRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PizzaImage")
                myRequest.predicate = NSPredicate(format: "imgUrl = %@", (self.pizza?.imgUrl)!)
                let imgData = try self.managedObjectContext.fetch(myRequest).first as? PizzaImage
                let image: UIImage
                if imgData == nil {
                    // if no image is found, cache it
                    let pizzaImage:PizzaImage = PizzaImage(entity: NSEntityDescription.entity(forEntityName: "PizzaImage", in: self.managedObjectContext)!, insertInto: self.managedObjectContext)
                    
                    pizzaImage.imgUrl = self.pizza?.imgUrl
                    let imageData = try Data(contentsOf: URL(string: (self.pizza?.imgUrl)!)!)
                    image = UIImage(data: imageData)!
                    pizzaImage.imgData = imageData as NSData?
                    
                    self.managedObjectContext.insert(pizzaImage)
                    
                    self.appDelegate.saveContext()
                } else {
                    // using cached images
                    image = UIImage(data: imgData?.imgData as! Data)!
                }
                
                self.ImageViewPicture.image = image
                
                
            } catch let error as NSError {
                print("The error is \(error.userInfo)")
            }
            
            self.hideLoadingScreen()
        }
    }
}
