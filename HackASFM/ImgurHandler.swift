//
//  ImgurHandler.swift
//  HackASFM
//
//  Created by Rodrigo Chousal on 3/25/17.
//  Copyright © 2017 Rodrigo Chousal. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ImgurHandler {
    
    // MARK: - POST
    
    func post(image: UIImage, for username: String, completionHandler: @escaping (String?, String?, Error?) -> ()) {
        makeCall(image: image, for: username, completionHandler: completionHandler)
    }
    
    func makeCall(image: UIImage, for username: String, completionHandler: @escaping (String?, String?, Error?) -> ()) {
        
        let imageData = UIImagePNGRepresentation(image)
        let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        let url = "https://api.imgur.com/3/upload"
        
        let parameters = [
            "image": base64Image,
            "name": username
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image, 1) {
                multipartFormData.append(imageData, withName: username, fileName: "\(username).png", mimeType: "image/png")
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value?.data(using: .utf8))!, withName: key)
            }}, to: url, method: .post, headers: ["Authorization": "Client-ID " + Constants.IMGUR_CLIENT_ID],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.response { response in
                            let jsonResponse = try? JSON(data: response.data!)
                            guard let response = jsonResponse else { return }
                            let imageURL = response["data"]["link"].stringValue
                            let deleteHash = response["data"]["deletehash"].stringValue
                            
                            print(response)
                            completionHandler(imageURL, deleteHash, nil)
                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                        completionHandler(nil, nil, encodingError)
                    }
        })
        
    }
    
    // MARK: - DELETE
    
    func delete(hash: String) {
        
        let url = "https://api.imgur.com/3/image/\(hash)"
        
        Alamofire.request(url, method: .delete, headers: ["Authorization": "Client-ID " + Constants.IMGUR_CLIENT_ID]).responseJSON { (response) in
            print(response)
        }
    }
    
}

