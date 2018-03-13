//
//  MapViewController.swift
//  HackASFM
//
//  Created by Rodrigo Chousal on 3/7/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapTableView: UITableView!
    
    var mapImages: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.black,
             NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 18)!]
        
        mapTableView.layer.cornerRadius = 10
        mapTableView.layer.masksToBounds = true
        
        mapTableView.delegate = self
        mapTableView.dataSource = self
        
        DispatchQueue.global(qos: .background).async {
            self.loadMapImages()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableViewDataSource
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as UITableViewCell
        
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: cell.frame.width, height: cell.frame.height))
        let image = mapImages[indexPath.row]
        imageView.image = image
        cell.addSubview(imageView)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // open window with more info
    }
    
    // MARK: - Map Image Handler
    
    func loadMapImages() {
        
        for (_, subJson):(String, JSON) in (jsonData?["map"])! {
            let imageURL = URL(string: subJson.stringValue)
            let data = try? Data(contentsOf: imageURL!)
            if let image = UIImage(data: data!) {
                self.mapImages.append(image)
            }
        }
        
        DispatchQueue.main.async {
            self.mapTableView.reloadData()
        }
    }
}
