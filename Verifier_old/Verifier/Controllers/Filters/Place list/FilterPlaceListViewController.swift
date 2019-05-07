//
//  PlaceListViewController.swift
//  Verifier
//
//  Created by Mac on 4/27/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit

class FilterPlaceListViewController: VerifierAppDefaultViewController {

    //MARK: - Outlets
    @IBOutlet weak var placeTableView: UITableView!
    @IBOutlet weak var placeSearchBar: UISearchBar!
    @IBOutlet weak var headerView: UIView!
    
    //MARK: - Properties
    let menuHeaderVC = R.storyboard.menuHeader.menuHeaderVC()
    var placeList = [String]()
    var model = FilterPlaceListModel()
    var preparePlace = DelegetedManager<(Place)>()
    
    //MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSearchController()
    }
    
    //MARK: - Methods
    private func prepareSearchController() {
        placeSearchBar.delegate = self
        placeSearchBar.showsCancelButton = true
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel".localized()

        placeSearchBar.becomeFirstResponder()
    }
    
    //MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

//MARK: - UITableViewDataSource
extension FilterPlaceListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.Indentifiers.filterPlaceCell.rawValue) as? FilterPlaceTableViewCell else {
            return UITableViewCell()
        }
        
        let index = indexPath.row
        let address = placeList[index]
        cell.updateContent(location: address)
        
        return cell
    }
    
}

//MARK: UITableViewDelegate
extension FilterPlaceListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let address = placeList[index]
        model.getCoordinateByAddress(with: address) { [weak self] in
            
            switch $0 {
            case .success(let place):
                self?.preparePlace.callback?(place)
                self?.navigationController?.popViewController(animated: true)
            default: break
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension FilterPlaceListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.getPlaceList(with: searchText) { [weak self] in
            switch $0 {
            case .success(let list):
                self?.placeList = list
                self?.placeTableView.reloadData()
            default: break
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
}
