//
//  ViewDroneItem.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/9/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import Foundation
import UIKit

let dataArray = [DroneModel(name: "Swift"), DroneModel(name: "Objective C"), DroneModel(name: "Java"), DroneModel(name: "Kotlin"), DroneModel(name: "Java Script")]


class ViewDroneModelItem{
    private var item: DroneModel
    
    var isSelected = false
    
    var title: String {
        return item.name
    }
    
    init(item: DroneModel) {
        self.item = item
    }
    
}

class ViewModel: NSObject {
    var items = [ViewDroneModelItem]()
    
    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }
    
    var selectedItems: [ViewDroneModelItem] {
        return items.filter { return $0.isSelected }
    }
    
    override init() {
        super.init()
        items = dataArray.map { ViewDroneModelItem(item: $0) }
    }
}

extension ViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? DroneTableViewCell {
            cell.item = items[indexPath.row]
            
            // select/deselect the cell
            if items[indexPath.row].isSelected {
                if !cell.isSelected {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                if cell.isSelected {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items[indexPath.row].isSelected = true
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items[indexPath.row].isSelected = false
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedItems.count > 2 {
            return nil
        }
        return indexPath
    }
}
