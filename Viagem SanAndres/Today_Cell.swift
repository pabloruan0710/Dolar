//
//  Today_Cell.swift
//  SanAndres
//
//  Created by Pablo on 10/30/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import UIKit

class Today_Cell: UITableViewCell {

    
    @IBOutlet weak var LB_Moeda: UILabel!
    @IBOutlet weak var LB_Valor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
