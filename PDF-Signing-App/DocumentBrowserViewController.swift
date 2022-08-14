//
//  DocumentBrowserViewController.swift
//  PDF-Signing-App
//
//  Created by Егор Бадмаев on 14.08.2022.
//

import UIKit
import QuickLook

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    var documentUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
    }
    
    
    // MARK: - UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let newDocumentURL: URL? = nil
        
        if newDocumentURL != nil {
            importHandler(newDocumentURL, .move)
        } else {
            importHandler(nil, .none)
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // TODO: Handle the failed import
    }
    
    // MARK: - Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        self.documentUrl = documentURL
        self.documentUrl?.startAccessingSecurityScopedResource()
        let qlController = QLPreviewController()
        qlController.dataSource = self
        present(qlController, animated: true, completion: nil)
    }
}

// MARK: - QLPreviewControllerDataSource

extension DocumentBrowserViewController: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let documentUrl = documentUrl else {
            fatalError("Document URL is nil at previewItemAt method")
        }
        return documentUrl as QLPreviewItem
    }
}
