//
//  DocumentViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 19/02/2019.
//  Copyright © 2019 Verifier. All rights reserved.
//

import UIKit
import PDFKit

class DocumentViewController: VerifierAppDefaultViewController, DocumentModelDelegate {
    
    //MARK: - OUTLETS
    @IBOutlet weak var viewWithPdf: PDFView!
    @IBOutlet var documentView: DocumentView!
    
    //MARK: - PROPERTIES
    var model = DocumentModel()
    var documentId: Int?
    var documentName: String?
    var documentType: String?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.delegate = self
    
        viewWithPdf.displayMode = .singlePageContinuous
        viewWithPdf.usePageViewController(false)
        viewWithPdf.pageBreakMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        viewWithPdf.autoScales = true
       
        if let _documentName = documentName {
            documentView.screenTitle.text = _documentName
        }
        
        if let _documentId = documentId, let _documentType = documentType  {
            model.getUserContractDownload(documentId: _documentId, documentType: _documentType)
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LOAD")
        

        
    }
    
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - DELEGATE
    
    func showAlertError(with title: String?, message: String?) {
        showAlert(title: title ?? "", message: message ?? "")
    }
    
    func hideSpinnerView() {
        super.hideSpinner()
    }
    
    func updateInformation(data: URL) {
        if let document = PDFDocument(url: data) {
            viewWithPdf.document = document
            
        }
        
    }
    
    
}
