//
//  TB_Roteiros_Cell.swift
//  Dolar
//
//  Created by Pablo on 10/26/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import UIKit

class TB_Roteiros_Cell: UITableViewCell {

    @IBOutlet weak var LB_Cor: UILabel!
    @IBOutlet weak var LB_Titulo: UILabel!
    @IBOutlet weak var LB_Status: UILabel!
    @IBOutlet weak var IMG_Icone: UIImageView!
    
    @IBOutlet weak var BT_Vamos: UIButton!
    @IBOutlet weak var BT_Talvez: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
