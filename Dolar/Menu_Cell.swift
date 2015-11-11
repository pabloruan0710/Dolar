//
//  Menu_Cell.swift
//  Dolar
//
//  Created by Pablo on 10/9/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import UIKit

class Menu_Cell: UITableViewCell {
    
    @IBOutlet weak var IMG_Menu: UIImageView!
    @IBOutlet weak var LB_DescricaoMenu: UILabel!
   
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func ConfiguraMenus(TextoMenu:String, ImagemMenu:String) {
        
        LB_DescricaoMenu.text = TextoMenu
        IMG_Menu.image = UIImage(named: ImagemMenu)
        
        
    }

}
