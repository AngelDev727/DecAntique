//
//  ShoppingCartVC.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 03/04/1443 AH.
//

import UIKit

class ShoppingCartVC: BaseVC, UISearchBarDelegate {
        
    @IBOutlet weak var uiTableview: UITableView!
    
    @IBOutlet weak var uiSearchbar: UISearchBar!
    var allData = [ProductModel]()
    var dataSource = [ProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSearchbar.delegate = self
        uiTableview.dataSource = self
        uiTableview.delegate = self
        uiTableview.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        allData = DataBaseHelper.shared.getCartListByUser(user_id: Int32(userDefaluts.integer(forKey: "user_id")))!
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
    private func callShoppingCartItem(_ indexPath: IndexPath) {
        let userId = Int32(userDefaluts.integer(forKey: "user_id"))
        
        if userId == 0 {
            showAlert("Please login to add or remove Shopping cart.")
            return
        }
        
        let message = "Would you like to remove this from shopping cart?"
        self.showAlert(title: nil, message: message, positive: "OK", negative: "CANCEL") {
            let res = DataBaseHelper.shared.removeCart(product_id: self.dataSource[indexPath.row].id, user_id: userId)
            
            if res.hasPrefix("success") {
                self.dataSource.remove(at: indexPath.row)
                self.uiTableview.reloadData()
            }
        }
    }
}

extension ShoppingCartVC: UITableViewDelegate, UITableViewDataSource {
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
        
        let action = UIContextualAction(style: .normal, title: "Remove", handler: { (action, view, completionHandler) in
            
            self.callShoppingCartItem(indexPath)
            completionHandler(true)
        })

        action.image = UIImage(systemName: "trash")
        action.image?.withTintColor(.systemGreen)
        action.backgroundColor = .systemOrange

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let data = dataSource[indexPath.row].photo, let img = UIImage(data: data) {
            let rate = img.size.height / img.size.width
            return self.view.bounds.size.width * rate
        }
        return 350
    }
    
}
