
//
//  ScheduleViewController.swift
//  HackASFM
//
//  Created by Rodrigo Chousal on 3/7/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

var jsonData: JSON? // GLOBAL VARIABLE - ALL VIEW CONTROLLERS CAN ACCESS IT

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scheduleTableView: UITableView!
    
    let schedule: Schedule = Schedule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.black,
             NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 18)!]
        
        scheduleTableView.layer.cornerRadius = 10
        
        // Only view controller that runs this function because it is the first one to load. Other view controllers only access global variable.
        downloadJSONGist(downloadURL: Constants.gistLink)
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - More Info Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoreInfoSegue" {
            
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = schedule.eventList[indexPath.row].name
        cell.detailTextLabel?.text = schedule.eventList[indexPath.row].time
                
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - JSON Handling
    
    func downloadJSONGist(downloadURL: String) {
        
        /* Only view controller that runs this function because it is the first one to load.
         Other view controllers only access global variable. Must make sure to have
         loading screen while downloading to avoid crash if user attempts to access
         other view controller. */
        
        DispatchQueue.global(qos: .background).async {
            Alamofire.request(downloadURL).responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: Any] else {
                    print("Invalid tag information received from the service")
                    return
                }
                
                jsonData = JSON(responseJSON)
                
                DispatchQueue.main.async {
                    self.loadSchedule()
                }
            }
        }
    }
    
    func loadSchedule() {
        for (index, subJson):(String, JSON) in (jsonData?["schedule"])! {
            
            let eventTime = subJson["time"].stringValue
            let eventName = subJson["name"].stringValue
            let eventDesc = subJson["desc"].stringValue
            
            let event: Event = Event(time: eventTime, name: eventName, desc: eventDesc)
            schedule.eventList.append(event)
        }
        
        // Uses downloaded JSON data, needs full data before execution
        DispatchQueue.main.async {
            self.scheduleTableView.reloadData()
        }
        
    }
    
    
}

