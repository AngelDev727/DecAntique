//
//  UserListVC.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 04/04/1443 AH.
//

import UIKit

class UserListVC: BaseVC {

    @IBOutlet weak var uiTableview: UITableView!
    var dataSource = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiTableview.delegate = self
        uiTableview.dataSource = self
        uiTableview.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let temp = DataBaseHelper.shared.getAllUsers() {
            dataSource = temp.filter { $0.type == "customer"}
        }
        
        uiTableview.reloadData()
    }
    
    private func callUserItem(_ indexPath: IndexPath) {
        
        let message = "Would you like to delete this user?"
        showAlert(title: nil, message: message, positive: "OK", negative: "CANCEL") {
            let res = DataBaseHelper.shared.deleteUser(user_id: self.dataSource[indexPath.row].id!)
            
            if res == "success" {
                self.dataSource.remove(at: indexPath.row)
                self.uiTableview.reloadData()
            }
        }
    }
}

extension UserListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.entity = dataSource[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .normal, title: "Delete", handler: { (action, view, completionHandler) in
            
            self.callUserItem(indexPath)
            completionHandler(true)
        })

        action.image = UIImage(systemName: "trash")
        action.image?.withTintColor(.systemGreen)
        action.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
        
    }

}
