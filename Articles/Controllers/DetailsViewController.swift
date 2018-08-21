//
//  ViewController.swift
//  PlantsRecognition
//
//  Created by Anna on 5/20/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreData
import WebKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var url: URL?
    
    var records: [NSManagedObject] = []
    var record: NSManagedObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        if let url = url {
            activityIndicator.startAnimating()
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}


extension DetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
