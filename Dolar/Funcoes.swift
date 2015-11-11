//
//  Funcoes.swift
//  Dolar
//
//  Created by Pablo on 10/9/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

func CoresMenu() -> NSArray{
   return ["#1abc9c","#e67e22","#3498db","#c0392b","#8e44ad","#2ecc71","#34495e","#f39c12","#2980b9","#1abc9c","#2c3e50"]
}


func Alerta(texto:String) {
    let alert = UIAlertView(title: "Atenção", message: texto, delegate: nil, cancelButtonTitle: "OK")
    alert.show()
}


extension String {
    func StringtoDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

//Função para pegar dados nsuserdefaults

func RetornaNSDefault(key:String)-> AnyObject{
    var ret:AnyObject!
    if let retorno = NSUserDefaults.standardUserDefaults().valueForKey(key) {
        ret = retorno
    }else{
        ret = ""
    }
    
    return ret
}


//PEGAR VALOR DO DOLAR
func Dolar() -> String {
    var Dolar:String = String()
    request(.GET, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDBRL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
        .responseJSON{resposta in
            
            if resposta.result.isSuccess {
                NSUserDefaults.standardUserDefaults().setObject(resposta.result.value, forKey: "Dolar")
                
                if let R_DLR = resposta.result.value?.objectForKey("query")?.objectForKey("results")?.objectForKey("rate")?.valueForKey("Rate") as? String{
                    NSUserDefaults.standardUserDefaults().setObject(R_DLR, forKey: "Dolar")
                    Dolar = R_DLR
                }else{
                    Dolar = ""
                }
                
                print("DOLAR \(Dolar)")
                
            }else{
                
                if let Dlr = NSUserDefaults.standardUserDefaults().valueForKey("Dolar") as? String {
                    Dolar = Dlr
                }
                
                print(resposta.result.error)
            }
            
    }
    
    return Dolar
}

//PEGAR VALOR PESO MEXICANO
func PesoMXN()->String{
    var MXN:String = String()
    request(.GET, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22MXNBRL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
        .responseJSON{resposta in
            
            if resposta.result.isSuccess {
                
                if let R_MXN = resposta.result.value?.objectForKey("query")?.objectForKey("results")?.objectForKey("rate")?.valueForKey("Rate") as? String{
                    NSUserDefaults.standardUserDefaults().setObject(R_MXN, forKey: "MXN")
                    MXN = R_MXN
                }else{
                    MXN = ""
                }
                
                print("MXN \(MXN)")
            }else{
                
                if let pmxn = NSUserDefaults.standardUserDefaults().valueForKey("MXN") as? String {
                    MXN = pmxn
                }
                print(resposta.result.error)
            }
            
    }
    
    return MXN
    
}


func PesoCOL()->String{
    var COP:String = String()
    //https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22COPBRL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys
    //https://api.mercadolibre.com/currency_conversions/search?from=COP&to=BRL
    request(.GET, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22COPBRL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
        .responseJSON{resposta in
            
            if resposta.result.isSuccess {
                
                if let R_COP = resposta.result.value?.objectForKey("query")?.objectForKey("results")?.objectForKey("rate")?.valueForKey("Rate") as? String{
                    NSUserDefaults.standardUserDefaults().setObject(R_COP, forKey: "COP")
                    COP = R_COP
                }else{
                    COP = ""
                }
                
                print("COP \(COP)")
                
            }else{
                
                if let pmxn = NSUserDefaults.standardUserDefaults().valueForKey("COP") as? String {
                    COP = pmxn
                }else{
                    COP = ""
                }
                print(resposta.result.error)
                
            }
            
    }
    
    return COP
}


//NAVIGATION BAr COLOR


extension UINavigationController {
    
    func NavigationBarCor(bar:UINavigationController){
        bar.navigationBar.tintColor = UIColor.whiteColor()
        bar.navigationBar.barTintColor = UIColor(rgba: "#3498db")
        bar.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
}


