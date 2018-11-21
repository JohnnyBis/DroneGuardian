//
//  MissionViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/5/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import UIEmptyState

var missionIndex = 0
var documentId: String = ""
var missionList = [Missions]()

class MissionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIEmptyStateDelegate, UIEmptyStateDataSource{
    

    @IBOutlet weak var missionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missionTableView.delegate = self
        missionTableView.dataSource = self
        print(missionList.count)
        self.missionTableView.addSubview(self.refreshControl)
        
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        // Remove seperator lines from empty cells
        self.missionTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.view.backgroundColor = UIColor(red: 0.518, green: 0.576, blue: 0.604, alpha: 1.00)
        missionTableView.reloadData()
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadEmptyStateForTableView(missionTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMissions(){
        Missions.fetchUserMissions(uid: uid!) { (mission) in
            missionList.append(mission)
            if let tabItems = self.tabBarController?.tabBar.items {
                let count = missionList.count
                let tabItem = tabItems[2]
                tabItem.badgeValue = "\(count)"
                self.missionTableView.reloadData()
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MissionViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    func emptyStatebuttonWasTapped(button: UIButton) {
//        fetchMissions()
//        missionTableView.reloadData()
//        reloadEmptyStateForTableView(missionTableView)
        emptyStateView.isHidden = true
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        missionList = []
        fetchMissions()
        refreshControl.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = missionTableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath)
        let post = missionList[indexPath.row]
        
        cell.textLabel?.text = "Your have a new order from \(post.client)."
        cell.detailTextLabel?.text = "Check the map and start your mission."
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        missionIndex = indexPath.row
        documentId = missionList[indexPath.row].documentId
        performSegue(withIdentifier: "goToSelectedMissionFromList", sender: self)
    }
    
    // MARK: - Empty State Data Source
    
    var emptyStateImage: UIImage? {
        return #imageLiteral(resourceName: "default icon")
    }
    
    var emptyStateTitle: NSAttributedString {
        let attrs = [NSAttributedStringKey.foregroundColor: UIColor(red: 0.882, green: 0.890, blue: 0.859, alpha: 1.00),
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22)]
        return NSAttributedString(string: "No Missions Available.", attributes: attrs)
    }
    
    var emptyStateButtonTitle: NSAttributedString? {
        let attrs = [NSAttributedStringKey.foregroundColor: UIColor.white,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        return NSAttributedString(string: "Try again", attributes: attrs)
    }
    
    var emptyStateButtonSize: CGSize? {
        return CGSize(width: 100, height: 40)
    }
    
    
    // MARK: - Empty State Delegate
    
    func emptyStateViewWillShow(view: UIView) {
        guard let emptyView = view as? UIEmptyStateView else { return }
        // Some custom button stuff
        emptyView.button.layer.cornerRadius = 5
        emptyView.button.layer.borderWidth = 1
        emptyView.button.layer.borderColor = UIColor(red:0.21, green:0.73, blue:0.70, alpha:1.0).cgColor
        emptyView.button.layer.backgroundColor = UIColor(red:0.21, green:0.73, blue:0.70, alpha:1.0).cgColor
    }
    
    

}
