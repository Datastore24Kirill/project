//
//  TaskFilteCategoryTableView.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 12/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class TaskFilteCategoryTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - OUTLETS
    
    //MARK: - PROPERTIES
    var orderCategoryArray: [[String : Any]]?    
    let resultFilterRealm = RealmSwiftFilterAction.listRealm()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView()
    }
    
    func reloadTable(data: [[String : Any]]) {
        
        orderCategoryArray = data
        self.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderCategoryArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTypeCell", for: indexPath) as! TaskFilterOrderTypeCell
        
        let dict = orderCategoryArray?[indexPath.row]
        
        cell.orderLevelLabel.text = dict?["description"] as? String
        cell.orderLevelButton.fieldId = dict?["id"] as? Int
        
        cell.orderLevelButton.addTargetClosure(){button in
            
            let cellButton = button as? verifierUIButton
            print("button \(String(describing: cellButton?.fieldId))")
            self.resetAllOrderLevel()
            self.changeFilterOrderLevel(value: cellButton?.fieldId ?? 0)
            
        }
        
        let filter = resultFilterRealm.first
        if let orderLevel = filter?.orderTypeId,
            let orderLevelServer = dict?["id"] as? Int {
            if orderLevel == orderLevelServer {
                cell.orderLevelBackgroundView.backgroundColor = UIColor("#E8E8FF")
                cell.orderLevelIcon.alpha = 1
            } else {
                cell.orderLevelBackgroundView.backgroundColor = UIColor.clear
                cell.orderLevelIcon.alpha = 0
            }
        } else {
            if indexPath.row == 0 {
                cell.orderLevelBackgroundView.backgroundColor = UIColor("#E8E8FF")
                cell.orderLevelIcon.alpha = 1
            }
        }
        
        return cell
    }
    
    func resetAllOrderLevel(){
        
        for cell in self.visibleCells {
            if cell.isKind(of: TaskFilterOrderTypeCell.self){
                let orderLevelCell = cell as! TaskFilterOrderTypeCell
                
                orderLevelCell.orderLevelIcon.alpha = 0
                orderLevelCell.orderLevelBackgroundView.backgroundColor = UIColor.clear
            }
        }
    }
    
    func changeFilterOrderLevel(value: Int) {
        for cell in self.visibleCells {
            if cell.isKind(of: TaskFilterOrderTypeCell.self){
                let orderLevelCell = cell as! TaskFilterOrderTypeCell
                if orderLevelCell.orderLevelButton.fieldId == value {
                    orderLevelCell.orderLevelBackgroundView.backgroundColor = UIColor("#E8E8FF")
                    orderLevelCell.orderLevelIcon.alpha = 1
                }
                
            }
        }
        
        
        RealmSwiftFilterAction.updateRealm(priceOrder: nil, dist: nil, orderTypeId: Int64(value), orderLevel: nil, verifTimeTo: nil, available: false)
    }
    
    
    
    
    
    
}
