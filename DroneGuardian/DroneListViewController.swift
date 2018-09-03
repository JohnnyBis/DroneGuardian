//
//  DroneListViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/9/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit

class DroneListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var droneList: UITableView!
    var list = ["Autel Evo",
        "Autel X-Star Premium",
        "DJI Inspire 1",
        "DJI Inspire 1 V2.0",
        "DJI Inspire 2",
        "DJI Matrice 100",
        "DJI Matrice 200",
        "DJI Matrice 210",
        "DJI Matrice 210 RTK",
        "DJI Matrice 600",
        "DJI Matrice 600 Pro",
        "DJI Mavic Air",
        "DJI Mavic Pro",
        "DJI Mavic Pro Platinum",
        "DJI Phantom 3 4K",
        "DJI Phantom 3 Advanced",
        "DJI Phantom 3 Professional",
        "DJI Phantom 3 Standard",
        "DJI Phantom 4",
        "DJI Phantom 4 Advanced",
        "DJI Phantom 4 Pro",
        "DJI Phantom 4 Pro Obsidian",
        "DJI Phantom 4 Pro Plus",
        "DJI Phantom 4 Pro V2.0",
        "DJI S1000+",
        "DJI Spark",
        "Yuneec H520",
        "Yuneec Tornado H920",
        "Yuneec Tornado H920 Plus",
        "Yuneec Typhoon 4K",
        "Yuneec Typhoon H",
        "Yuneec Typhoon H Plus"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        droneList.delegate = self
        droneList.dataSource = self
        self.droneList.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParentViewController{
            DataService.ds.REF_USERS.document(uid!).setData(["Drones": selectedCells], merge: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = droneList.dequeueReusableCell(withIdentifier: "droneCell", for: indexPath as IndexPath)

        cell.textLabel?.text = list[indexPath.row]
        
        cell.accessoryType = selectedCells.contains(list[indexPath.row]) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedCells.contains(list[indexPath.row]) {
            let position = selectedCells.index(of: list[indexPath.row])
            selectedCells.remove(at: position!)
        } else {
            selectedCells.append(list[indexPath.row])
        }
        print(selectedCells)
        droneList.reloadData()
    }

    
}
