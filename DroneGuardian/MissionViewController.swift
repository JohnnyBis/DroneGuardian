//
//  MissionViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/5/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit

var missionIndex = 0
var documentId: String = ""

class MissionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var missionTableView: UITableView!
    
    var missionList = [Missions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missionTableView.delegate = self
        missionTableView.dataSource = self
        fetchMissions()
        print(missionList.count)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMissions(){
        Missions.fetchUserMissions(uid: uid!) { (mission) in
            self.missionList.append(mission)
            DispatchQueue.main.async {
                self.missionTableView.reloadData()
            }
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = missionTableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath)
        let post = missionList[indexPath.row]
        cell.textLabel?.text = "Order from \(post.client)                 \(post.price)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        missionIndex = indexPath.row
        documentId = missionList[indexPath.row].documentId
        performSegue(withIdentifier: "goToSelectedMissionFromList", sender: self)
    }
    
    

}
