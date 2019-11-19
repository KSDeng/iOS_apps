//
//  TodoCell.swift
//  Todos
//
//  Created by DKS_mac on 2019/11/12.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {

    
    @IBOutlet weak var checkLabel: UILabel!
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
