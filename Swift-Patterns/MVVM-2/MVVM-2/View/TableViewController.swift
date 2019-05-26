//
//  TableViewController.swift
//  MVVM-2
//
//  Created by Кирилл Ковыршин on 13/05/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var viewModel: TableViewViewModelType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel()
      
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel?.numberOfRows() ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell

        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell()}
   
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel

        return tableViewCell
    }
    


}
