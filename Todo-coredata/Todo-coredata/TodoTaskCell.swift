//
//  TodoTaskCell.swift
//  Todo-coredata
//
//  Created by DKS_mac on 2019/11/21.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit

class TodoTaskCell: UITableViewCell {

    
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
