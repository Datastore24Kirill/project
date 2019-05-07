//
//  FiltersViewController.swift
//  Verifier
//
//  Created by Mac on 4/23/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import CoreLocation

class FiltersViewController: VerifierAppDefaultViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var saveButton: GradientButton!
    @IBOutlet weak var showSaveButtonContraint: NSLayoutConstraint!
    @IBOutlet weak var hideSaveButtonContraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var titleHeader: UILabel!
    //MARK: - Properties
    var pickerVC = FilterPickerViewController()
//    let menuHeaderVC = R.storyboard.menuHeader.menuHeaderVC()
    var model = FilterModel()
    
    var filterList = [FilterDataHeaderModel]()
    var showSection = IndexPath(row: -1, section: -1)
    
    var contentList = [FilterContentModel]()
    var radiusList = [String]()
    var rangeOfOrderExecutionList = [String]()

    var parameters = User.Filter()
    
    var currentUserLocation: Place!
    
    enum ViewControllerss: String {
        case filterPickerVC = "FilterPickerVC"
        case filterPlaceListVC = "FilterPlaceListVC"
    }
    
    var typePickerItem = TypePickerItem.none
    enum TypePickerItem {
        case rangeOfOrderExecution
        case byRadius
        case byContents
        case none
    }
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleHeader.text = "Filters".localized()
//        prepareHeaderView()
        prepareText()
        prepareData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        getCurrentUserLocation {}
    }
    
    override func viewDidLayoutSubviews() {
        saveButton?.violetButton = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didPressMenuButton(_ sender: Any) {
        
        openMenu()
    }
    //MARK: - Methods
//    private func prepareHeaderView() {
//
//
//        controller.preparePressMenuButton.delegate(to: self) { (self, _) in
//            self.openMenu()
//        }
//        controller.view.frame = UIScreen.main.bounds
//        controller.view.frame.size.height = 85
//        view.addSubview(controller.view)
//    }
    
    private func prepareText() {
        saveButton.setTitle("Save".localized(), for: .normal)
    }
    
    private func prepareData() {
        
        // Register Nib
        model.getCellIndentifier().forEach {
            filterTableView.register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)
        }
        
        // Get data
        rangeOfOrderExecutionList = model.getRangeOfOrderExecutionList()
        radiusList = model.getRadiusList()
        model.getContentList { [weak self] in
            switch $0 {
            case .success(let list):
                self?.contentList = list
                if let res = self?.isShowDot(with: .byContents) {
                    self?.filterList[3].isHiddenDot = res
                }
                self?.reloadSections(with: [3])
            default: break
            }
        }
        
        filterList = model.getFilterDataHeaderList()
        filterList[0].isHiddenDot = isShowDot(with: .rangeOfOrderExecution)
        filterList[2].isHiddenDot = isShowDot(with: .byRadius)
    }
    
    private func isShowDot(with type: TypePickerItem) -> Bool {
        switch type {
        case .rangeOfOrderExecution:
            return getCurrentTitle(with: type) == rangeOfOrderExecutionList.first
        case .byRadius:
            return getCurrentTitle(with: type) == radiusList.first
        case .byContents:
            return getCurrentTitle(with: type) == contentList.first?.description
        default: return true
        }
    }
    
    private func getCurrentTitle(with type: TypePickerItem) -> String {
        switch type {
        case .byContents:
            let userContent = UserDefaultsVerifier.getFilterParameters()?.content?.description
            let selectContent = parameters.content?.description
            let defContent = contentList.first?.description
            return selectContent ?? userContent ?? defContent ?? ""
        case .byRadius:
            let userContent = UserDefaultsVerifier.getFilterParameters()?.radius
            let selectContent = parameters.radius
            let defContent = radiusList.first?.description
            return selectContent ?? userContent ?? defContent ?? ""
        case .rangeOfOrderExecution:
            let userContent = UserDefaultsVerifier.getFilterParameters()?.rangeOfOrderExecution
            let selectContent = parameters.rangeOfOrderExecution
            let defContent = rangeOfOrderExecutionList.first?.description
            return selectContent ?? userContent ?? defContent ?? ""
        default: return ""
        }
    }
    
    private func getCurrentUserLocation(closure: @escaping ()->()) {
        let locationManager = CLLocationManager()
        if let coordinate = locationManager.location?.coordinate {
            showSpinner()
            currentUserLocation = Place(cor: coordinate, name: "")
            GoogleManager.getAddressByCoordinate(with: coordinate) { [weak self] in
                switch $0 {
                case .success(let name):
                    self?.currentUserLocation.name = name
                default: break
                }
                
                self?.reloadSections(with: [1])
                
                self?.hideSpinner()
            }
        }
    }
    
    private func getLocation() -> Place? {
        let filter = UserDefaultsVerifier.getFilterParameters()
        let selectAddress = parameters.address
        let userAddress = filter?.address
        
        return selectAddress ?? userAddress ?? currentUserLocation
        
    }
    
    private func showButtonAndReloadTable() {
        showSaveButtonContraint.priority = UILayoutPriority(rawValue: 999.0)
        hideSaveButtonContraint.priority = UILayoutPriority(rawValue: 333.0)
        self.filterTableView.reloadData()
    }
    
    private func hideButtonAndReloadTable() {
        showSaveButtonContraint.priority = UILayoutPriority(rawValue: 333.0)
        hideSaveButtonContraint.priority = UILayoutPriority(rawValue: 999.0)
        self.filterTableView.reloadData()
    }
    
    private func isShowSaveButton() {
        
        guard let filter = UserDefaultsVerifier.getFilterParameters() else {
            showButtonAndReloadTable()
            return
        }
        
        if let newRangeOfOrderExecution = parameters.rangeOfOrderExecution,
            newRangeOfOrderExecution != filter.rangeOfOrderExecution {
            showButtonAndReloadTable()
        } else if parameters.address != filter.address {
            showButtonAndReloadTable()
        } else if let newRadius = parameters.radius,
            newRadius != filter.radius {
            showButtonAndReloadTable()
        } else if let newContent = parameters.content?.description,
            newContent != filter.content?.description {
            showButtonAndReloadTable()
        } else {
            showButtonAndReloadTable()
        }
        
    }
    
    private func setTitleSelectPickerItem(with value: String) {
        switch typePickerItem {
        case .rangeOfOrderExecution:
            parameters.rangeOfOrderExecution = value
        case .byRadius:
            parameters.radius = value
        case .byContents:
            
            guard let item = contentList.first(where: { $0.description == value }) else {
                return
            }
            
            parameters.content = item
        case .none: break
        }
    }
    
    private func openPickerView(with controller: FiltersViewController, parameters: (values: [String], title: String, type: TypePickerItem)) {
        guard let picker = InternalHelper.StoryboardType.filter.getStoryboard().instantiateViewController(withIdentifier: ViewControllerss.filterPickerVC.rawValue) as? FilterPickerViewController else {
            return
        }
        
        let type = parameters.type
        self.pickerVC = picker
        self.typePickerItem = type
        self.pickerVC.delegate = self
        self.pickerVC.pickerDataList = parameters.values
        self.pickerVC.pickerTitel = parameters.title
        self.pickerVC.nameChoosedItem = self.getCurrentTitle(with: type)
        self.pickerVC.view.frame = UIScreen.main.bounds
        self.view.addSubview(self.pickerVC.view)
    }
    
    private func saveLocationOnServer(closure: @escaping ()->()) {
        
        guard let addressFilter = UserDefaultsVerifier.getFilterParameters()?.address ,
        let addressParameters = parameters.address else {
            closure()
            return
        }
        
        if addressFilter != addressParameters {
            showSpinner()
            model.prepareSaveLocation.delegate(to: self) { (self, response) in
                closure()
                self.hideSpinner()
            }
            model.saveUserLocation(with: addressParameters)
        }
    
    }
    
    //MARK: - Actions
    @IBAction func didPressSaveButton(_ sender: UIButton) {
        saveLocationOnServer { [weak self] in
            
            guard let param = self?.parameters else { return }
            UserDefaultsVerifier.setFilterParameters(with: param)
            
            if let res = self?.isShowDot(with: .rangeOfOrderExecution) {
                self?.filterList[0].isHiddenDot = res
            }
            
            if let res = self?.isShowDot(with: .byRadius) {
                self?.filterList[2].isHiddenDot = res
            }
            
            if let res = self?.isShowDot(with: .byContents) {
                self?.filterList[3].isHiddenDot = res
            }
            
            self?.hideButtonAndReloadTable()
        }
    }
    

    @IBAction func didPressBackButton(_ sender: Any) {
        
        if let window = AppDelegate.getWindow() {
            
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.dashboardVC.rawValue
            
            if let dashoboardVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? DashboardNavigationViewController {
                window.rootViewController = dashoboardVC
            }
        }
    }
    
    
}

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList[section].opened ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.Indentifiers.filterHeaderCell.rawValue) as? FilterHeaderTableViewCell {
                
                cell.element = filterList[indexPath.section]
                return cell
            }
            
        } else {
            
            switch indexPath.section {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersUINibs.Indentifiers.filterRangeOfOrderExecutionViewCell.rawValue) as? FilterRangeOfOrderExecutionViewCell {
                    
                    let title = getCurrentTitle(with: .rangeOfOrderExecution)
                    cell.updateTitle(with: title)
                    cell.openPickerView.delegate(to: self) { (self, parameters) in
                        self.openPickerView(with: self, parameters: parameters)
                    }
                    return cell
                }
            case 1:
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersUINibs.Indentifiers.filterMapTableViewCell.rawValue) as? FilterMapTableViewCell {
                    
                    cell.updateAddress(with: getLocation())
                    
                    cell.addThisViewControllerAsChild.delegate(to: self) { (self, mapVC) in
                        self.addChildViewController(mapVC)
                    }
                    
                    cell.preparePlace.delegate(to: self) { (self, place) in
                        self.parameters.address = place
                        self.isShowSaveButton()
                    }
                    
                    cell.showOrHideSpinner.delegate(to: self) { (self, res) in
                        res ? self.showSpinner() : self.hideSpinner()
                    }
                    
                    cell.openSearchPlace.delegate(to: self) { (self, _) in
                        let storyboard = InternalHelper.StoryboardType.filter.getStoryboard()
                        let identifier = ViewControllerss.filterPlaceListVC.rawValue
                        guard let controller = storyboard.instantiateViewController(withIdentifier: identifier) as? FilterPlaceListViewController else {
                            return
                        }
                        
                        controller.preparePlace.delegate(to: self) { (self, place) in
                            self.parameters.address = place
                            self.reloadSections(with: [1])
                            self.isShowSaveButton()
                        }
                        
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    
                    return cell
                }
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersUINibs.Indentifiers.filterRadiusTableViewCell.rawValue) as? FilterRadiusTableViewCell {
                    
                    let title = getCurrentTitle(with: .byRadius)
                    cell.updateTitle(with: title)
                    cell.values = radiusList
                
                    cell.openPickerView.delegate(to: self) { (self, parameters) in
                        self.openPickerView(with: self, parameters: parameters)
                    }
                    
                    return cell
                }
            case 3:
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiersUINibs.Indentifiers.filterContentTableViewCell.rawValue) as? FilterContentTableViewCell {
                    
                    let title = getCurrentTitle(with: .byContents)
                    cell.updateTitle(with: title)
                    cell.values = contentList
                    cell.openPickerView.delegate(to: self) { (self, parameters) in
                        self.openPickerView(with: self, parameters: parameters)
                    }
                    
                    return cell
                }
            default: break
            }
            
        }
        
        return UITableViewCell()
    }
    
}

//MARK: - UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let titleHeight: CGFloat = 88
        var buttonHeight: CGFloat = 0
        
        if showSaveButtonContraint.priority == UILayoutPriority(rawValue: 999.0) {
            buttonHeight = 56
        }
        
        let height = UIScreen.main.bounds.height - titleHeight - buttonHeight
        
        if indexPath.row == 0 {
            let heightHeder = (height * 0.46641791) / 4
            return heightHeder
        } else {
            let heightBody = height * 0.53358209
            return heightBody
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            var arrayIndex = [Int]()
            
            //adding old section to array
            if let oldSection = getOldSectionAndHide(with: indexPath) {
                arrayIndex.append(oldSection)
            }
            
            arrayIndex.append(indexPath.section)
            hideOrShowSection(with: indexPath.section)
            reloadSections(with: arrayIndex)
            showSection = indexPath
        }
    }
    
    private func getOldSectionAndHide(with newIndexPath: IndexPath) -> Int? {
        guard showSection.section != -1 && showSection != newIndexPath else {
            return nil
        }
        
        filterList[showSection.section].opened = false
        return showSection.section
        
    }
    
    private func hideOrShowSection(with section: Int) {
        filterList[section].opened = !filterList[section].opened
    }
    
    func reloadSections(with array: [Int]) {
        let sections = IndexSet(array)
        filterTableView.reloadSections(sections, with: .automatic)
    }
    
}

//MARK: - FilterPickerDataProtocol
extension FiltersViewController: FilterPickerDataProtocol {
    func didChosePickerItem(value: String) {
        pickerVC.view.removeFromSuperview()
        
        setTitleSelectPickerItem(with: value)
        isShowSaveButton()
        
        switch typePickerItem {
        case .rangeOfOrderExecution:
            
            if let cell = filterTableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? FilterRangeOfOrderExecutionViewCell {
                cell.choiceDateButton.setTitle(parameters.rangeOfOrderExecution, for: .normal)
            }
            
        case .byRadius:
            
            if let cell = filterTableView.cellForRow(at: IndexPath(item: 1, section: 2)) as? FilterRadiusTableViewCell {
                cell.choiceDateButton.setTitle(parameters.radius, for: .normal)
            }
            
        case .byContents:
            
            if let cell = filterTableView.cellForRow(at: IndexPath(item: 1, section: 3)) as? FilterContentTableViewCell {
                cell.choiceDataLabel.text = parameters.content?.description
            }
            
        case .none: break
        }
        
    }
    
    func didCancelPickerData() {
        pickerVC.view.removeFromSuperview()
    }
    
}
