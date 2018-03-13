//
//  ScoringViewController.swift
//  HackASFM
//
//  Created by Rodrigo Chousal on 3/7/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class ScoringViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.black,
             NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 18)!]
        
        mainView.layer.cornerRadius = 10
        mainView.alpha = 1.0
        mainView.backgroundColor = .white
        
        webView.uiDelegate = self
        
        let url = jsonData!["scoring"].stringValue
        webView.load(Alamofire.URLRequest(url: URL(string: url)!) as URLRequest)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
