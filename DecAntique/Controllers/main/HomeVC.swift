//
//  HomeVC.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 02/04/1443 AH.
//

import UIKit

class HomeVC: BaseVC, UISearchBarDelegate {

    @IBOutlet weak var uiSearchbar: UISearchBar!
    @IBOutlet weak var uiTableview: UITableView!
    
    var allData = [ProductModel]()
    var dataSource = [ProductModel]()
    var userType = "customer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSearchbar.delegate = self
        uiTableview.delegate = self
        uiTableview.dataSource = self
        uiTableview.tableFooterView = UIView()

        userType = userDefaluts.string(forKey: "user_type") ?? "customer"
        
        if userDefaluts.string(forKey: "user_type") == "manager" {
            self.tabBarController?.viewControllers?.remove(at: 1)
        } else {
            self.tabBarController?.viewControllers?.remove(at: 2)
        }
        
        let userID = Int32(userDefaluts.integer(forKey: "user_id"))
        
        if userID == 0 {
            self.tabBarController?.viewControllers?.remove(at: 3)
        }
        
        addNavButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userID = userType == "customer" ? Int32(userDefaluts.integer(forKey: "user_id")) : nil
        allData = DataBaseHelper.shared.getAllProducts(user_id: userID)!
        dataSource = allData
        uiTableview.reloadData()
    }
    
    
    //MARK: - delegate uisearchbar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            showAlert("Please input product name.")
            return
        }
        
        dataSource = allData.filter { $0.product_name.lowercased().contains(searchBar.text!.lowercased())}
        uiTableview.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        dataSource = allData.filter { $0.product_name.lowercased().contains(searchText.lowercased())}
        uiTableview.reloadData()
    }
    
    //MARK: - custom function
    func addNavButton() {
        
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        
        //left barbutton
        let butExit = UIButton(type: .custom)
        
        butExit.setImage(UIImage(systemName: "power", withConfiguration: config), for: .normal)
        butExit.addTarget(self, action: #selector(self.addTappedSignout), for: .touchUpInside)
        butExit.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        butExit.tintColor = .systemBlue
        let barButtonItemExit = UIBarButtonItem(customView: butExit)
        barButtonItemExit.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButtonItemExit.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.navigationItem.leftBarButtonItem = barButtonItemExit
        
        if userType == "manager" {
            //right barbutton
            let butAdd = UIButton(type: .custom)
            butAdd.setImage(UIImage (systemName: "plus.circle", withConfiguration: config), for: .normal)
            butAdd.addTarget(self, action: #selector(self.addTappedAdd), for: .touchUpInside)
            butAdd.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            butAdd.tintColor = .systemBlue
            let barButtonItemAdd = UIBarButtonItem(customView: butAdd)
            barButtonItemAdd.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
            barButtonItemAdd.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true
            self.navigationItem.rightBarButtonItem = barButtonItemAdd
        }
       
    }
    
    @objc func addTappedSignout(isConfirm: Bool) {
        if userDefaluts.string(forKey: "user_email") == "" || userDefaluts.string(forKey: "user_email") == nil {
            self.gotoVC("AuthNav", true)
        } else {
            showAlert(title: "Would you like to log out?", message: nil, positive: "Log Out", negative: "Cancel") {
                self.userDefaluts.set(0, forKey: "user_id")
                self.userDefaluts.set("", forKey: "user_name")
                self.userDefaluts.set("", forKey: "user_email")
                self.userDefaluts.set("", forKey: "user_type")
                
                self.gotoVC("AuthNav", true)
            }
        }
    }
    
    @objc func addTappedAdd(isConfirm: Bool) {
        gotoNavVC("AddNewProduct")
    }

    private func callShoppingCartItem(_ indexPath: IndexPath) {
        
        let addedCart = dataSource[indexPath.row].added_cart
        let userId = Int32(userDefaluts.integer(forKey: "user_id"))
        
        if userId == 0 {
            showAlert("Please login to add or remove Shopping cart.")
            return
        }
        
        
        let message = addedCart ? "Would you like to remove this from shopping cart?"
                        : "Would you like to add this from shopping cart?"
        showAlert(title: nil, message: message, positive: "OK", negative: "CANCEL") {
            var res = ""
            if addedCart {
                res = DataBaseHelper.shared.removeCart(product_id: self.dataSource[indexPath.row].id, user_id: userId)
            } else {
                res = DataBaseHelper.shared.addCart(product_id: self.dataSource[indexPath.row].id, user_id: userId)
            }

            if res.hasPrefix("success") {
                self.dataSource[indexPath.row].added_cart = !addedCart
                self.uiTableview.reloadData()
            }
        }
    }
    
    func callDeleteItem(_ indexPath: IndexPath)  {
        
        let userId = Int32(userDefaluts.integer(forKey: "user_id"))
        
        if userId == 0 {
            showAlert("Please login to delete product.")
            return
        }
        
        let message = "Would you like to delete this product?"
        showAlert(title: nil, message: message, positive: "OK", negative: "CANCEL") {
            let res =  DataBaseHelper.shared.removeProduct(product_id: self.dataSource[indexPath.row].id)

            if res.hasPrefix("success") {
                self.dataSource.remove(at: indexPath.row)
                self.uiTableview.reloadData()
            }
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.entity = dataSource[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let toVC = self.storyboard?.instantiateViewController( withIdentifier: "SingleProductVC") as! SingleProductVC
        toVC.product = dataSource[indexPath.row]
        self.navigationController?.pushViewController(toVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if userType == "manager" {
            let action = UIContextualAction(style: .normal, title: "Delete", handler: { (action, view, completionHandler) in
                
                self.callDeleteItem(indexPath)
                completionHandler(true)
            })

            action.image = UIImage(systemName: "trash")
            action.image?.withTintColor(.systemGreen)
            action.backgroundColor = .red

            let configuration = UISwipeActionsConfiguration(actions: [action])
            return configuration
        }
        
        let flag = dataSource[indexPath.row].added_cart
        let title = flag ? "Remove" : "Add"
        let icon = flag ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        let action = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in
            
            self.callShoppingCartItem(indexPath)
            completionHandler(true)
        })

        action.image = icon
        action.image?.withTintColor(.systemGreen)
        action.backgroundColor = flag ? .systemOrange : .red

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //when product image exist
        if let data = dataSource[indexPath.row].photo, let img = UIImage(data: data) {
            let rate = img.size.height / img.size.width
            return 300
//            self.view.bounds.size.width * rate
        }
        
        //default - when no image
        return 250
    }
    
    

}
