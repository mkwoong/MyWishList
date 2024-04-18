//
//  ViewController.swift
//  MyWishList
//
//  Created by 문기웅 on 4/18/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    private func loadData() {
        let productID = Int.random(in: 1 ... 100)
        
        if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        let productData = try JSONDecoder().decode(Products.self, from: data)
                        self.decodeProduct = productData
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    private var decodeProduct: Products? = nil {
        didSet {
            guard let decodeProduct = self.decodeProduct else {return}
            
            DispatchQueue.main.async {
                self.productImage.image = nil
                self.productTitle.text = decodeProduct.title
                self.productDescription.text = decodeProduct.description
                self.productPrice.text = "$\(decodeProduct.price)"
            }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: decodeProduct.thumbnail), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.productImage.image = image }
                }
            }
        }
    }
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    private func addWishProduct() {
        guard let context = self.persistentContainer?.viewContext else {return}
        
        guard let decodeProduct = self.decodeProduct else {return}
        
        let wishProduct = Product(context: context)
        
        wishProduct.id = Int64(decodeProduct.id)
        wishProduct.title = decodeProduct.title
        wishProduct.price = decodeProduct.price
        
        try? context.save()
    }
    
    @IBAction func addWishList(_ sender: UIButton) {
        self.addWishProduct()
    }
    
    @IBAction func showOtherProduct(_ sender: Any) {
        self.loadData()
    }
    
    @IBAction func showWishList(_ sender: Any) {
    }
    
}

