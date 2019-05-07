//
//  CreateTaskFirstStepViewController.swift
//  Verifier
//
//  Created by Yatseyko Yuriy on 01.05.2018.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol CreateTaskFirstStepViewControllerOutput: class {
    func showPicker(for items: [String], selectedValue: String)
    func showDatePicker(selectedDate: Date, pickerType: DatePickerType)
    
    func getContentList()
    
    func openSecondStage()
    func openMapSearch()
}

protocol CreateTaskFirstStepViewControllerInput: class {
    func provideContentListData(result: ServerResponse<[FilterContentModel]>)
}

class CreateTaskFirstStepViewController: VerifierAppDefaultViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var navSubTitleLabel: UILabel!
    
    @IBOutlet weak var isPhisicalSwitch: UISwitch!
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var descrTextView: UITextView!
    
    @IBOutlet weak var switchLabel: UILabel!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    
    @IBOutlet weak var orderSubjectLabel: UILabel!
    @IBOutlet weak var orderSubjectValueLabel: UILabel!
    @IBOutlet weak var orderSubjectView: UIView!
    @IBOutlet weak var appShareTextLabel: UILabel!
    
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var dateFromLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    
    @IBOutlet weak var dateFromButton: UIButton!
    @IBOutlet weak var dateToButton: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Properties
    var presenter: CreateTaskFirstStepViewControllerOutput!
    
    var mapVC = FilterMapViewController()
    
    var subjects: [FilterContentModel] = [FilterContentModel]()
    
    var dateFromValidate = false
    var dateToValidate = false
    
    //MARK: - UIViewController methods
    override func awakeFromNib() {
        super.awakeFromNib()
        CreateTaskFirstStepAssembly.sharedInstance.configure(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewOrder.sharedInstance.resetFields()
        
        DispatchQueue.main.async {
            self.prepareMap(with: nil)
        }
        prepareUI()
        prepareData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - UI
    func prepareUI() {
        navTitleLabel.text = "My Orders".localized()
        navSubTitleLabel.text = "Step 1".localized()
        
        taskTitleLabel.text = "Order name".localized()
        descrLabel.text = "Description".localized()
        switchLabel.text = "Switch label".localized()
        
        lastNameTextField.placeholder = "Last name".localized()
        firstNameTextField.placeholder = "First name".localized()
        middleNameTextField.placeholder = "Middle name".localized()
        
        dateFromButton.titleLabel?.text = "dd.mm.yyyy".localized()
        dateToButton.titleLabel?.text = "dd.mm.yyyy".localized()
    
        orderSubjectLabel.text = "Subject of order".localized()
        orderSubjectView.layer.cornerRadius = 10.0
        appShareTextLabel.text = "".localized()
        
        dateTitleLabel.text = "Date title".localized()
        dateView.layer.cornerRadius = 10.0
        
        dateFromLabel.text = "From".localized()
        dateToLabel.text = "To".localized()
        
        addressLabel.text = "Address".localized()
        addressTextField.placeholder = "Address placeholder".localized()
        mapView.layer.cornerRadius = 10.0
        nextButton.backgroundColor = UIColor.verifierBlueColor()
        nextButton.layer.cornerRadius = 5.0
        nextButton.setTitle("Next".localized(), for: .normal)
    }
    
    func prepareMap(with place: Place?) {
        mapVC = R.storyboard.map.filterMapVC()!
        
        if let address = place {
            mapVC.coordinate = address.coordinate
        } else {
            mapVC.coordinate = CLLocationCoordinate2D(latitude: 55.740557, longitude: 37.610006)
        }

        self.getCoordinates(coordinate: mapVC.coordinate)
        
        mapVC.view.frame = mapView.bounds
        mapView.addSubview(mapVC.view)
        
        mapVC.prepareMap()
        
        mapVC.didSelectMap.delegate(to: self) { (self, coordinate) in
            self.getCoordinates(coordinate: coordinate)
        }        
    }
    
    func getCoordinates(coordinate: CLLocationCoordinate2D) {
        GoogleManager.geocoderGetAddressByCoordinate(with: coordinate) {

            switch $0 {
            case .success(let location):
                let country = location.addressDictionary!["Country"] ?? ""
                let state = location.addressDictionary!["State"] ?? ""
                let name = location.addressDictionary!["Name"] ?? ""

                let address = "\(country), \(state), \(name)"
                self.addressTextField.text = address
                NewOrder.sharedInstance.address = address
                NewOrder.sharedInstance.lat = coordinate.latitude
                NewOrder.sharedInstance.lng = coordinate.longitude
            default: break
            }
        }
        /*
        GoogleManager.getAddressByCoordinate(with: coordinate) {
            switch $0 {
            case .success(let name):
                self.addressTextField.text = name
                let place = Place(cor: coordinate, name: name)
                NewOrder.sharedInstance.address = place.name
                NewOrder.sharedInstance.lat = place.coordinate.latitude
                NewOrder.sharedInstance.lng = place.coordinate.longitude
            default: break
            }
        }*/
    }
    
    func validateFields() {
        var validateResult = false

        if isPhisicalSwitch.isOn {
            validateResult =
                taskTitleTextField.text != "" &&
                descrTextView.text != "" &&
                firstNameTextField.text != "" &&
                lastNameTextField.text != "" &&
                middleNameTextField.text != "" &&
                dateFromValidate &&
                dateToValidate
        } else {
            validateResult =
                taskTitleTextField.text != "" &&
                descrTextView.text != "" &&
                dateFromValidate &&
                dateToValidate
        }

        if validateResult {
            nextButton.alpha = 1.0
            nextButton.isEnabled = true
        } else {
            nextButton.alpha = 0.5
            nextButton.isEnabled = false
        }
    }

    func validateOrderDate(newDate: Date, pickerType: DatePickerType) {
        let dateFormatter = DateFormatter()
        let dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.dateFormat = dateFormat
        let dateFromString = self.dateFromButton.titleLabel?.text!
        let dateToString = self.dateToButton.titleLabel?.text!

        let dateFrom = dateFormatter.date(from: dateFromString!)
        let dateTo = dateFormatter.date(from: dateToString!)

        switch pickerType {
        case .newOrderDateFrom:
            if let dateTo = dateTo {
                switch dateTo.compare(newDate) {
                case .orderedAscending:
                    print("Date A is earlier than date B")
                    self.dateFromButton.setTitle(dateTo.getDateString(with: dateFormat), for: .normal)
                    self.dateToButton.setTitle(newDate.getDateString(with: dateFormat), for: .normal)

                    NewOrder.sharedInstance.dateFrom = dateTo
                    NewOrder.sharedInstance.dateTo = newDate

                case .orderedDescending:
                    print("Date A is later than date B")
                    self.dateFromButton.setTitle(newDate.getDateString(with: dateFormat), for: .normal)

                    NewOrder.sharedInstance.dateFrom = newDate

                case .orderedSame:
                    print("The two dates are the same")
                    self.dateFromButton.setTitle(newDate.getDateString(with: dateFormat), for: .normal)
                    NewOrder.sharedInstance.dateFrom = newDate
                }
            } else {
                self.dateFromButton.setTitle(newDate.getDateString(with: dateFormat), for: .normal)
                NewOrder.sharedInstance.dateFrom = newDate
            }

        case .newOrderDateTo:
            if let dateFrom = dateFrom {
                switch newDate.compare(dateFrom) {
                case .orderedAscending:
                    print("Date A is earlier than date B")
                    self.dateFromButton.setTitle(newDate.getDateString(with: dateFormat), for: .normal)
                    self.dateToButton.setTitle(dateFrom.getDateString(with: dateFormat), for: .normal)

                    NewOrder.sharedInstance.dateFrom = newDate
                    NewOrder.sharedInstance.dateTo = dateFrom

                case .orderedDescending:
                    print("Date A is later than date B")

                    self.dateToButton.setTitle(newDate.getDateString(with: dateFormat), for: .normal)
                    NewOrder.sharedInstance.dateTo = newDate

                case .orderedSame:
                    print("The two dates are the same")
                    self.dateToButton.setTitle(newDate.getDateString(with: dateFormat), for: .normal)
                    NewOrder.sharedInstance.dateTo = newDate
                }
            } else {
                self.dateToButton.setTitle(newDate.getDateString(with: dateFormat), for: .normal)
                NewOrder.sharedInstance.dateTo = newDate
            }
        default:
            break
        }
    }

    // MARK: - Data
    func prepareData() {
        showSpinner()
        presenter.getContentList()
    }
    
    // MARK: - Actions
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        openMenu()
    }
    
    @IBAction func orderSubjectButtonTapped(_ sender: UIButton) {
        var arr: [String] = [String]()
        for item in subjects {
            arr.append(item.description)
        }
        guard let subject = NewOrder.sharedInstance.selectedSubject else {
            return
        }
        presenter.showPicker(for: arr, selectedValue: subject.description)
    }

    @IBAction func phisicalVerificationSwitchAction(_ sender: UISwitch) {

        lastNameTextField.isEnabled = sender.isOn
        firstNameTextField.isEnabled = sender.isOn
        middleNameTextField.isEnabled = sender.isOn

        validateFields()
    }
    
    @IBAction func didEnterText(_ sender: UITextField) {
        validateFields()
    }
    
    
    @IBAction func dateFromButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        presenter.showDatePicker(selectedDate: NewOrder.sharedInstance.dateFrom, pickerType: .newOrderDateFrom)
    }
    
    @IBAction func dateToButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        presenter.showDatePicker(selectedDate: NewOrder.sharedInstance.dateTo, pickerType: .newOrderDateTo)
    }

    @IBAction func addressButtonTapped(_ sender: UIButton) {
        presenter.openMapSearch()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        NewOrder.sharedInstance.orderName = taskTitleTextField.text!
        
        NewOrder.sharedInstance.orderComment = descrTextView.text
        
        NewOrder.sharedInstance.isPhisical = isPhisicalSwitch.isOn
        
        NewOrder.sharedInstance.orderFirstName = firstNameTextField.text!
        NewOrder.sharedInstance.orderLastName = lastNameTextField.text!
        NewOrder.sharedInstance.orderMiddleName = middleNameTextField.text!

        presenter.openSecondStage()
        
    }

}

extension CreateTaskFirstStepViewController: CreateTaskFirstStepViewControllerInput {
    func provideContentListData(result: ServerResponse<[FilterContentModel]>) {
        hideSpinner()
        switch result {
        case .success(let list):
            self.subjects = list
            if self.subjects.count  > 0 {
                NewOrder.sharedInstance.selectedSubject = self.subjects[0]
                self.orderSubjectValueLabel.text = NewOrder.sharedInstance.selectedSubject?.description
            }
        default: break
        }
    }
}

extension CreateTaskFirstStepViewController: VerifierPickerProtocol {
    func closePicker(picker: UIViewController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    func selectValue(in array: [String], for index: Int, picker: UIViewController) {
        picker.dismiss(animated: false) { [weak self] in
            NewOrder.sharedInstance.selectedSubject = self?.subjects[index]
            self?.orderSubjectValueLabel.text = NewOrder.sharedInstance.selectedSubject?.description
        }
    }
}

extension CreateTaskFirstStepViewController: DatePickerPickerProtocol {
    func didCancelDatePicker() {
        dismiss(animated: false, completion: nil)
    }
    
    func didChoseDate(date: Date, pickerType: DatePickerType) {
        dismiss(animated: false) { 
            switch pickerType {
            case .newOrderDateFrom:
                //self.dateFromButton.setTitle(date.getDateString(with: "dd.MM.yyyy HH:mm"), for: .normal)
                self.validateOrderDate(newDate: date, pickerType: .newOrderDateFrom)

                self.dateFromValidate = true
            case .newOrderDateTo:

                self.validateOrderDate(newDate: date, pickerType: .newOrderDateTo)
                //self.dateToButton.setTitle(date.getDateString(with: "dd.MM.yyyy HH:mm"), for: .normal)
                self.dateToValidate = true
            default: break
            }
            self.validateFields()
        }
    }
}

//MARK: - UITextViewDelegate
extension CreateTaskFirstStepViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        validateFields()
    }
}

extension CreateTaskFirstStepViewController: GMSAutocompleteViewControllerDelegate {

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true) {
            let place = Place(cor: place.coordinate, name: place.formattedAddress ?? place.name)

            self.addressTextField.text = place.name
            self.prepareMap(with: place)
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }

    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}
