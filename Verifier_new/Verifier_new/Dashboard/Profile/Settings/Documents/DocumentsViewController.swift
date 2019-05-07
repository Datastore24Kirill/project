//
//  DocumentsViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit

class DocumentsViewController: VerifierAppDefaultViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DocumentsModelDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet var documentsView: DocumentsView!
    @IBOutlet weak var collectionView: UICollectionView!

    
    
    
    //MARK: - PROPERTIES
    var deviceName = UIDevice.modelName
    var documentsArray = [[String : Any]]()
    let model = DocumentsModel()
    let cellReuseIdentifier = "DocumentСell"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        documentsView.localizationView()
        model.delegate = self
        showSpinner()
        model.getUserContractList()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOAD")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - COLLECTION DELEGATE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return documentsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = documentsArray[section]["data"] as! [[String:Any]]
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! DocumentViewCell
        let data = documentsArray[indexPath.section]["data"] as! [[String:Any]]
        let dict = data[indexPath.row]
        
        cell.cellView.layer.cornerRadius = 5
        cell.cellView.layer.borderColor = UIColor.black.cgColor
        cell.cellView.layer.borderWidth = 1
        
        cell.descriptionLabel.text = dict["documentName"] as? String
        
        print("DICT \(data)")
     
        
       
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! DocumentViewHeaderCell
            
            let data = documentsArray[indexPath.section]
            headerView.headerLabel.text = data["documentTypeName"] as? String
            
            return headerView
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 160, height: 160)
        if deviceName == "Simulator iPhone SE" {
            size = CGSize(width: 130, height: 130)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let documentInfo = documentsArray[indexPath.section]
        let data = documentInfo["data"] as! [[String:Any]]
        
        
        let documentType = documentInfo["documentType"]
        let documentId = data[indexPath.row]["documentId"]
        let documentName = data[indexPath.row]["documentName"]
        

        let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
        let indentifier = ViewControllers.documentVC.rawValue

        if let documentVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? DocumentViewController {
            documentVC.documentId = documentId as? Int
            documentVC.documentType = documentType as? String
            documentVC.documentName = documentName as? String
            self.navigationController?.pushViewController(documentVC, animated: true)

        }
//        print("DICT \(dict)")
        
    }
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func updateInformation(data: [[String: Any]]) {
        
        documentsArray = data
        collectionView.reloadData()
        
    }

    
    


}

class DocumentViewCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cellView: UIView!


}

class DocumentViewHeaderCell: UICollectionReusableView {
    
    @IBOutlet weak var headerLabel: UILabel!
    
}
