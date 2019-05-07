//
//  VerifyCollectionViewCell.swift
//  Verifier
//
//  Created by Dima Paliychuk on 5/30/18.
//  Copyright © 2018 Yatseyko Yuriy. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class VerifyCollectionViewCell: DefaultProfileCollectionViewCell {

    @IBOutlet private weak var mapView: UIView!
    @IBOutlet private weak var pickerLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var timeButtom: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var pickerTitleLabel: UILabel!
    @IBOutlet private weak var addressTextField: UITextField!
    
    private (set) var googleMapManager: GoogleMapManager!
    private var verifAddr: String?
    private var long: Double?
    private var lat: Double?
    private var timeTo: Int?
    
    var didPressAddressButton = DelegetedManager<()>()
    var didPressDatePickerButton = DelegetedManager<()>()
    var didPressSaveButton = DelegetedManager<(verifAddr: String, long: Double, lat: Double, timeTo: Int)>()
    var showAlertHandler = DelegetedManager<((title: String, message: String))>()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
        setupGoogleMapManager()
    }
    
    private func setupUI() {
        addressLabel.text = "Address".localized()
        addressTextField.placeholder = "Address placeholder".localized()
        timeLabel.text = "To".localized()
        timeButtom.titleLabel?.text = "dd.mm.yyyy".localized()
        pickerTitleLabel.text = "Date title".localized()
        saveButton.setTitle("Save".localized(), for: .normal)
    }
    
    private func setupGoogleMapManager() {
        googleMapManager = GoogleMapManager(mapView: mapView)
        googleMapManager.didGetNewCoordinat.delegate(to: self) { (self, arg1) in
            let (coordinate, address) = arg1
            self.verifAddr = arg1.address
            self.long = coordinate.longitude
            self.lat = coordinate.latitude
            self.addressTextField.text = address
        }
        DispatchQueue.main.async {
            self.googleMapManager.prepareMap(with: nil)
        }
    }
    
    @IBAction func addressButtonTapped(_ sender: UIButton) {
        didPressAddressButton.callback?(())
    }
    
    @IBAction func pickerButtonTapped(_ sender: UIButton) {
        didPressDatePickerButton.callback?(())
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let verifAddr = verifAddr, let long = long, let lat = lat, let timeTo = timeTo else {
            showAlertHandler.callback?((title: "InternetErrorTitle".localized(), message: "Choose a date".localized()))
            return
        }
        didPressSaveButton.callback?((verifAddr: verifAddr, long: long, lat: lat, timeTo: timeTo))
    }

}


//MARK: - date picker protocol

extension VerifyCollectionViewCell: DatePickerPickerProtocol {
    func didCancelDatePicker(datePickerViewController: UIViewController) {
        datePickerViewController.dismiss(animated: false, completion: nil)
    }
    
    func didChoseDate(datePickerViewController: UIViewController, date: Date, pickerType: DatePickerType) {
        datePickerViewController.dismiss(animated: false) { [weak self] in
            switch pickerType {
            case .newOrderTimeFrom:
                print("newOrderTimeFrom")
                self?.timeTo = Int((NewOrder.sharedInstance.dateTo.timeIntervalSince1970).rounded())
                self?.timeButtom.setTitle(date.getDateString(with: "dd.MM.yyyy HH:mm"), for: .normal)
            default:
                break
            }
        }
    }
}
