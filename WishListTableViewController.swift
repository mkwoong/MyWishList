//
//  WishListTableViewController.swift
//  MyWishList
//
//  Created by 문기웅 on 4/18/24.
//

import UIKit
import CoreData

class WishListTableViewController: UITableViewController {
    
    var persistentContainer: NSPersistentContainer? {
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        }
    
    private var wishProductList: [Product] = []
    
    private func setWishProductList() {
        guard let context = self.persistentContainer?.viewContext else {return}
        
        let request = Product.fetchRequest()
        
        if let wishProductList = try? context.fetch(request) {
            self.wishProductList = wishProductList
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        setWishProductList()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishProductList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! wishCell
        
        let wishProduct = self.wishProductList[indexPath.row]
        
        cell.wishProductID.text = "[wishProduct.id]"
        cell.wishProductTitle.text = wishProduct.title
        cell.wishProductPrice.text = "$\(wishProduct.price)"
        
        return cell
    }

   

}

class wishCell: UITableViewCell {
    @IBOutlet weak var wishProductID: UILabel!
    @IBOutlet weak var wishProductTitle: UILabel!
    @IBOutlet weak var wishProductPrice: UILabel!
    
}
