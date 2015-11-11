//
//  Cell_Cotacoes.swift
//  Dolar
//
//  Created by Pablo on 9/9/15.
//  Copyright (c) 2015 PrimeSoftware. All rights reserved.
//

import UIKit

class Cell_Cotacoes: UITableViewCell {

    @IBOutlet weak var LB_Moeda: UILabel!
    @IBOutlet weak var LB_Cotacao: UILabel!
    @IBOutlet weak var LB_Variacao: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func Configure(moeda:String, cotacao:String, varicao:String){
        LB_Moeda.text = moeda
        LB_Cotacao.text = cotacao
        LB_Variacao.text = varicao
    }

}
