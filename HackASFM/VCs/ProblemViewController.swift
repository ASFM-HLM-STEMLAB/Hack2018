//
//  ProblemViewController.swift
//  HackASFM
//
//  Created by Rodrigo Chousal on 3/7/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ProblemViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.black,
             NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 18)!]
        
        mainView.layer.cornerRadius = 10
        mainView.alpha = 1.0
        mainView.backgroundColor = .white
        
        titleLabel.text = jsonData?["problem"]["title"].stringValue
        descTextView.text = jsonData?["problem"]["description"].stringValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
