//
//  DroneTableViewCell.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/9/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit

class DroneTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    var item: ViewDroneModelItem? {
        didSet {
            name?.text = item?.title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // update UI
        accessoryType = selected ? .checkmark : .none
    }
    
}
