//
//  HomeVC.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 02/04/1443 AH.
//

import UIKit

class HomeVC: BaseVC {

    @IBOutlet weak var uiTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        uiTableview.delegate = self
        uiTableview.dataSource = self
    }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell

                cell.labUserName.text = "Name"
                cell.labMessage.text = "Message \(indexPath.row)"
        cell.labTime.text = NSDateFormatter.localizedStringFromDate(NSDate() as Date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)

                return cell
    }
    

}
