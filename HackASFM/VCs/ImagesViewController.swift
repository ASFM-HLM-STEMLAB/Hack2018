//
//  ImagesViewController.swift
//  HackASFM
//
//  Created by Rodrigo Chousal on 3/7/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    var eventImages: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.black,
             NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 18)!]
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        imagesCollectionView.layer.cornerRadius = 10
        
        DispatchQueue.global(qos: .background).async {
            self.loadEventImages()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string : (jsonData?["live-images"][indexPath.row].stringValue)!)!, options: [:], completionHandler: { (status) in
            
        })
    }
    
    // MARK: - Collection View DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as UICollectionViewCell
        
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: cell.frame.width, height: cell.frame.height))
        let image = eventImages[indexPath.row]
        imageView.image = image
        cell.addSubview(imageView)
        
        return cell
    }
    
    // MARK: - Event Image Handler
    
    func loadEventImages() {
        
        // _ is index
        for (_,subJson):(String, JSON) in (jsonData?["live-images"])! {
            
            let imageURL = URL(string: subJson.stringValue)
            
            let data = try? Data(contentsOf: imageURL!)
            
            if let image = UIImage(data: data!) {
                self.eventImages.append(image)
            }
        }
        
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
        }
    }
}
