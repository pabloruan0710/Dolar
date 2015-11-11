//
//  TB_Conversao_Cell.swift
//  Dolar
//
//  Created by Pablo on 10/9/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import UIKit

class TB_Conversao_Cell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var LB_Tipos: UILabel!
    @IBOutlet weak var LB_TextoResultado: UILabel!
    @IBOutlet weak var LB_Valor: UILabel!
    @IBOutlet weak var LB_ValorEm: UILabel!
    @IBOutlet weak var TXT_Valor: UITextField!
    @IBOutlet weak var BT_Calcular: UIButton!
    @IBOutlet weak var BT_Reset: UIButton!
    @IBOutlet weak var BT_Selecionado: UIButton!
    @IBOutlet weak var BG_Tipos: UIView!
    @IBOutlet weak var TXT_Produto: UITextField!
    @IBOutlet weak var VlrEmPESO: UIButton!
    
    
    var PESO_CONF:String!
    var DOLAR_CONF:String!
    var USAR_PESO:String!
    var PESO_ATUAL:String!
    var VALOR_EM_PESO_TROCO:Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func TiposConversao(Tipo:String, Cor:String){
        LB_Tipos.text = Tipo
        BG_Tipos.backgroundColor = UIColor(rgba: Cor)
        
    }
    
    func ResultadoConversao(TextoResultado:String, Valor:String){
        LB_TextoResultado.text = TextoResultado
        LB_Valor.text = Valor
        TXT_Valor.clipsToBounds = true
        TXT_Valor.layer.borderColor = UIColor.whiteColor().CGColor
        TXT_Valor.layer.borderWidth = 0.3
        
        TXT_Produto.clipsToBounds = true
        TXT_Produto.layer.borderColor = UIColor.whiteColor().CGColor
        TXT_Produto.layer.borderWidth = 0.3
        
    }
    
    @IBAction func Valor_Em_Peso(sender: AnyObject) {
        
        if let vlr_em_peso = RetornaNSDefault("VlrPeso") as? Bool where vlr_em_peso == true {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "VlrPeso")
            VlrEmPESO.setTitle("\u{f096}", forState: .Normal)
            VALOR_EM_PESO_TROCO = false
        }else{
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "VlrPeso")
            VlrEmPESO.setTitle("\u{f14a}", forState: .Normal)
            VALOR_EM_PESO_TROCO = true
            
        }
    }
    
    @IBAction func Converter(sender: AnyObject) {
        
        TXT_Valor.resignFirstResponder()
        
        //evitar erros
        USAR_PESO = "UsarPCOP"
        
        
        
        if let dest = RetornaNSDefault("Destino") as? String where dest != "" {
            if dest == "mexico" {
                USAR_PESO = "UsarPMXN"
                if let R_PMXN = RetornaNSDefault("PMXN") as? String {
                    PESO_CONF = R_PMXN
                }
                
                //PEGA PESO ATUAl
                if let MXN_AT = NSUserDefaults.standardUserDefaults().valueForKey("MXN") as? String {
                    PESO_ATUAL = MXN_AT as! String
                }
                
            }else if dest == "colombia" {
               
                USAR_PESO = "UsarPCOP"
                
                if let R_PCOP = RetornaNSDefault("PCOP") as? String {
                    PESO_CONF = R_PCOP
                }
                
                //PEGA PESO ATUAl
                if let pmxn = NSUserDefaults.standardUserDefaults().valueForKey("COP") as? String {
                    PESO_ATUAL = pmxn
                }
                
            }
            
        }else{
            //Padrão
            Alerta("Utilizando Peso Colombiano como Padrão, para alterar vá até configurações.")
            USAR_PESO = "UsarPCOP"
            NSUserDefaults.standardUserDefaults().setValue("colombia", forKey: "Destino")
            PESO_ATUAL = "0.00"
            //PEGA PESO ATUAl
            if let pmxn = NSUserDefaults.standardUserDefaults().valueForKey("COP") as? String {
                PESO_ATUAL = pmxn
                print(PESO_ATUAL)
            }else{
                PESO_ATUAL = "0.00"
            }
            
        }
       
        
        if let valortxt = TXT_Valor.text where valortxt != "", let selecionada = SelecionadaCalculo as? Int {
            
            
            
            switch selecionada {
                //REAL PARA PESO
                case 0:
                    TXT_Produto.hidden = true
                    let real:Double = 1
                    var resultado:Double!
                    
                    if let mxn = PESO_ATUAL {
                        var aux1RealCompra:Double!
                        var peso:Double!
                        
                        //VERIFICA SE USA DAS CONFIGURAÇÕES
                        if let U_MXN = RetornaNSDefault(USAR_PESO) as? Bool where U_MXN == true {
                            peso = (PESO_CONF).StringtoDouble()
                            print("USANDO PESO CONF \(peso)")
                        }else{
                            peso = (mxn as! String).StringtoDouble()
                            print("USANDO PESO COTAçÂO ATUAL \(peso)")
                        }
                        
                            aux1RealCompra = real/peso!
                            resultado = valortxt.StringtoDouble()! * aux1RealCompra
                        
                            LB_TextoResultado.text = "Total de Pesos:"
                            if "\(resultado)".characters.count > 9 {
                                LB_Valor.text = ("$ \(resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                            }else{
                                LB_Valor.text = "$ \(resultado)"
                            }
                        
                    }else{
                        var aux1RealCompra:Double!
                        var peso:Double!
                        peso = 0.0
                        //VERIFICA SE USA DAS CONFIGURAÇÕES
                        
                        if let U_MXN = RetornaNSDefault(USAR_PESO) as? Bool where U_MXN == true {
                            peso = (PESO_CONF).StringtoDouble()
                            print("USANDO PESO CONF \(peso)")
                        }else{
                            Alerta("Verifique sua Conexão!!!")
                            
                        }
                        
                        aux1RealCompra = real/peso!
                        resultado = valortxt.StringtoDouble()! * aux1RealCompra
                        LB_TextoResultado.text = "Total de Pesos:"
                        
                        if "\(resultado)".characters.count > 9 {
                            LB_Valor.text = ("$ \(resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                        }else{
                            LB_Valor.text = "$ \(resultado)"
                        }
                      
                    }
                //PESO PARA REAL
                case 1:
                    TXT_Produto.hidden = true
                    let real:Double = 1
                    var realcompraPeso:Double!
                
                    if let mxn = PESO_ATUAL {
                        
                        if let U_MXN = RetornaNSDefault(USAR_PESO) as? Bool where U_MXN == true {
                            realcompraPeso = (PESO_CONF).StringtoDouble()
                            print("USANDO PESO CONF \(realcompraPeso)")
                        }else{
                            realcompraPeso = (mxn as! String).StringtoDouble()
                            print("USANDO PESO COTAçÂO ATUAL \(realcompraPeso)")
                        }
                        
                        let aux = real/realcompraPeso
                        
                        let resultado = (valortxt).StringtoDouble()!/aux
                        
                        LB_TextoResultado.text = "Total de Reais:"
                        if "\(resultado)".characters.count > 9 {
                            LB_Valor.text = ("$ \(resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                        }else{
                            LB_Valor.text = "$ \(resultado)"
                        }
                        
                    }else{
                        if let U_MXN = RetornaNSDefault(USAR_PESO) as? Bool where U_MXN == true {
                            realcompraPeso = (PESO_CONF).StringtoDouble()
                            print("USANDO PESO CONF \(realcompraPeso)")
                        }else{
                            Alerta("Verifique sua Conexão!!!")
                        }
                        
                        let aux = real/realcompraPeso
                        
                        let resultado = (valortxt).StringtoDouble()!/aux
                        print(resultado)
                        LB_TextoResultado.text = "Total de Reais:"
                        if "\(resultado)".characters.count > 9 {
                            LB_Valor.text = ("$ \(resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                        }else{
                            LB_Valor.text = "$ \(resultado)"
                        }
                        
                    }
                
                
                //REAL PARA DOLAR
                case 2:
                    
                    TXT_Produto.hidden = true
                    var resultado:Double!
                    
                    if let dlr = NSUserDefaults.standardUserDefaults().valueForKey("DOLAR") as? String {
                        
                        if let U_DOLAR = RetornaNSDefault("UsarDOLAR") as? Bool where U_DOLAR == true {
                            if let usd = RetornaNSDefault("PDOLAR") as? String where usd != "" {
                                resultado = (valortxt as String).StringtoDouble()! / (usd).StringtoDouble()!
                                print("USANDO DOLAR CONF \(usd)")
                            }else{
                                
                                resultado = (valortxt as String).StringtoDouble()! / (dlr).StringtoDouble()!
                                print("USANDO DOLAR COTAÇÂO POIS NAO EXISTE DOLAR NA CONF \(dlr)")
                            }
                            
                        }else{
                           resultado = (valortxt as String).StringtoDouble()! / (dlr).StringtoDouble()!
                            print("USANDO DOLAR COTAÇÂO \(dlr)")
                        }
                        
                        LB_TextoResultado.text = "Total de Dolar:"
                        if "\(resultado)".characters.count > 9 {
                            LB_Valor.text = ("$ \(resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                        }else{
                            LB_Valor.text = "$ \(resultado)"
                        }
                        
                    }else{
                        if let U_DOLAR = RetornaNSDefault("UsarDOLAR") as? Bool where U_DOLAR == true {
                            if let usd = RetornaNSDefault("PDOLAR") as? String where usd != "" {
                                resultado = (valortxt as String).StringtoDouble()! / (usd).StringtoDouble()!
                                print("USANDO DOLAR CONF \(usd)")
                            }else{
                                Alerta("Verifique sua Conexão!!!")
                            }
                            
                        }else{
                            Alerta("Verifique sua Conexão!!!")
                        }
                        
                        LB_TextoResultado.text = "Total de Dolar:"
                        if "\(resultado)".characters.count > 9 {
                            LB_Valor.text = ("$ \(resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                        }else{
                            LB_Valor.text = "$ \(resultado)"
                        }
                    }
                //DOLAR PARA REAL
                case 3:
                    TXT_Produto.hidden = true
                    
                    var resultado:Double!
                    
                    if let dlr = NSUserDefaults.standardUserDefaults().valueForKey("DOLAR") as? String {
                        
                        if let U_DOLAR = RetornaNSDefault("UsarDOLAR") as? Bool where U_DOLAR == true {
                            if let usd = RetornaNSDefault("PDOLAR") as? String where usd != "" {
                                resultado = (valortxt as String).StringtoDouble()! * (usd).StringtoDouble()!
                                print("USANDO DOLAR CONF \(usd)")
                            }else{
                                
                                resultado = (valortxt as String).StringtoDouble()! * (dlr).StringtoDouble()!
                                print("USANDO DOLAR COTAÇÂO POIS NAO EXISTE DOLAR NA CONF \(dlr)")
                            }
                            
                        }else{
                            resultado = (valortxt as String).StringtoDouble()! * (dlr).StringtoDouble()!
                            print("USANDO DOLAR COTAÇÂO \(dlr)")
                        }

                        LB_TextoResultado.text = "Total de Reais:"
                        if "\(resultado)".characters.count > 9 {
                            LB_Valor.text = ("$ \(resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                        }else{
                            LB_Valor.text = "$ \(resultado)"
                        }
                        
                    }else{
                        if let U_DOLAR = RetornaNSDefault("UsarDOLAR") as? Bool where U_DOLAR == true {
                            if let usd = RetornaNSDefault("PDOLAR") as? String where usd != "" {
                                resultado = (valortxt as String).StringtoDouble()! * (usd).StringtoDouble()!
                                print("USANDO DOLAR CONF \(usd)")
                            }else{
                                Alerta("Verifique sua Conexão!!!")
                            }
                            
                        }else{
                            Alerta("Verifique sua Conexão!!!")
                        }
                        
                        LB_TextoResultado.text = "Total de Reais:"
                        if "\(resultado)".characters.count > 9 {
                            LB_Valor.text = ("$ \(resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                        }else{
                            LB_Valor.text = "$ \(resultado)"
                        }
                    }
                //PESO PARA DOLAR
                case 4:
                    TXT_Produto.hidden = true
                    var resultado:Double!
                    
                    if let dlr = NSUserDefaults.standardUserDefaults().valueForKey("DOLAR") as? String, let psomxn = PESO_ATUAL {
                        
                        var pesoEmReal:Double
                        
                        if let U_PESO = RetornaNSDefault(USAR_PESO) as? Bool where U_PESO == true {
                            pesoEmReal = 1/(PESO_CONF).StringtoDouble()!
                             print("USANDO PESO CONF \(PESO_CONF)")
                        }else{
                            pesoEmReal = 1/(psomxn).StringtoDouble()!
                        }
                        
                        if let U_DOLAR = RetornaNSDefault("UsarDOLAR") as? Bool where U_DOLAR == true {
                            if let R_DOLAR = RetornaNSDefault("PDOLAR") as? String where R_DOLAR != "" {
                               resultado = 1/((valortxt as String).StringtoDouble()! * ((R_DOLAR).StringtoDouble()! * pesoEmReal))
                                print("USANDO DOLAR CONF \(R_DOLAR)")
                            }else{
                               resultado = 1/((valortxt as String).StringtoDouble()! * ((dlr).StringtoDouble()! * pesoEmReal))
                            }

                        }else{
                            resultado = 1/((valortxt as String).StringtoDouble()! * ((dlr).StringtoDouble()! * pesoEmReal))
                        }
                        
                        LB_TextoResultado.text = "Total de Pesos:"
                        if "\(resultado)".characters.count > 9 {
                            LB_Valor.text = ("$ \(resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                        }else{
                            LB_Valor.text = "$ \(resultado)"
                        }
                       
                    }
                
                //DOLAR PARA PESO
                case 5:
                    TXT_Produto.hidden = true
                    var resultado:Double!
                    
                    if let dlr = NSUserDefaults.standardUserDefaults().valueForKey("DOLAR") as? String, let psomxn = PESO_ATUAL {
                        
                        var pesoEmReal:Double!
                        
                        if let U_PESO = RetornaNSDefault(USAR_PESO) as? Bool where U_PESO == true {
                            pesoEmReal = 1/(PESO_CONF).StringtoDouble()!
                            print("USANDO PESO CONF \(PESO_CONF)")
                        }else{
                            pesoEmReal = 1/(psomxn).StringtoDouble()!
                        }
                        
                        if let U_DOLAR = RetornaNSDefault("UsarDOLAR") as? Bool where U_DOLAR == true {
                            if let R_DOLAR = RetornaNSDefault("PDOLAR") as? String where R_DOLAR != "" {
                                resultado = (valortxt as String).StringtoDouble()! * ((R_DOLAR).StringtoDouble()! * pesoEmReal)
                                print("USANDO DOLAR CONF \(R_DOLAR)")
                            }else{
                                resultado = (valortxt as String).StringtoDouble()! * ((dlr).StringtoDouble()! * pesoEmReal)
                            }
                            
                        }else{
                            resultado = (valortxt as String).StringtoDouble()! * ((dlr).StringtoDouble()! * pesoEmReal)
                        }
                                              
                        LB_TextoResultado.text = "Total de Pesos:"
                        if "\(resultado)".characters.count > 9 {
                            LB_Valor.text = ("$ \(resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                        }else{
                            LB_Valor.text = "$ \(resultado)"
                        }
                        
                    }
                //TROCO EM PESO
                case 6:
                    print("")
                    TXT_Produto.hidden = false
                    TXT_Valor.placeholder = "Valor Pago em Dolar"
                    //TextoLBValor = "Valor pago em DOLAR: "
                
                    var troco:Double!
                    var Resultado:Double!
                    var ProdutoEmDolar:Double!
                    
                    if VALOR_EM_PESO_TROCO == false {
                        if let valorPago = TXT_Valor.text where valorPago != "", let valorProduto = TXT_Produto.text where valorProduto != "" {
                            troco = (valorPago).StringtoDouble()! - (valorProduto).StringtoDouble()!
                            
                        }
                    }else{
                        if let valorProd = TXT_Produto.text where valorProd != "" {
                            if let dlr = NSUserDefaults.standardUserDefaults().valueForKey("DOLAR") as? String, let psomxn = PESO_ATUAL {
                                
                                var resultado:Double!
                                var pesoEmReal1:Double
                                
                                if let U_PESO = RetornaNSDefault(USAR_PESO) as? Bool where U_PESO == true {
                                    pesoEmReal1 = 1/(PESO_CONF).StringtoDouble()!
                                    print("USANDO PESO CONF \(PESO_CONF)")
                                }else{
                                    pesoEmReal1 = 1/(psomxn).StringtoDouble()!
                                }
                                
                                if let U_DOLAR = RetornaNSDefault("UsarDOLAR") as? Bool where U_DOLAR == true {
                                    if let R_DOLAR = RetornaNSDefault("PDOLAR") as? String where R_DOLAR != "" {
                                        resultado = 1/((valorProd as String).StringtoDouble()! * ((R_DOLAR).StringtoDouble()! * pesoEmReal1))
                                        print("USANDO DOLAR CONF \(R_DOLAR)")
                                    }else{
                                        resultado = 1/((valorProd as String).StringtoDouble()! * ((dlr).StringtoDouble()! * pesoEmReal1))
                                    }
                                    
                                }else{
                                    resultado = 1/((valorProd as String).StringtoDouble()! * ((dlr).StringtoDouble()! * pesoEmReal1))
                                    
                                }
                                ProdutoEmDolar = resultado
                                
                                if let valorPago = TXT_Valor.text where valorPago != "" {
                                   troco = (valorPago).StringtoDouble()! - (valorProd).StringtoDouble()!
                                }
                                
                                print("VALOR DO PRODUTO CONVERTIDO PARA DOLAR \(resultado)")
                            }
                            
                        }
                        
                        
                    }
                
                
                    var pesoEmReal:Double!
                    
                    if let U_PESO = RetornaNSDefault(USAR_PESO) as? Bool where U_PESO == true {
                        pesoEmReal = 1/(PESO_CONF).StringtoDouble()!
                        print("USANDO PESO CONF \(PESO_CONF)")
                    }else{
                        if let psTu = PESO_ATUAL {
                            pesoEmReal = 1/(psTu).StringtoDouble()!
                        }
                    }
                    
                    if let U_DOLAR = RetornaNSDefault("UsarDOLAR") as? Bool where U_DOLAR == true {
                        if let R_DOLAR = RetornaNSDefault("PDOLAR") as? String {
                            Resultado = troco * R_DOLAR.StringtoDouble()! * pesoEmReal
                            print("Troco Em Dolar: \(troco)")
                            print("TROCO EM PESO -> \(Resultado)")
                        }
                    }else{
                        if let dolar = RetornaNSDefault("DOLAR") as? String where dolar != "" {
                            Resultado = troco * dolar.StringtoDouble()! * pesoEmReal
                        }
                        
                    }
                
                    LB_TextoResultado.text = "Troco em Pesos:"
                    if "\(Resultado)".characters.count > 9 {
                        LB_Valor.text = ("$ \(Resultado)" as NSString).substringWithRange(NSRange(location: 0,length: 9)) as String
                    }else{
                        LB_Valor.text = "$ \(Resultado)"
                    }
                
                //TROCO EM DOLAR
                case 7:
                    print("")
                    TXT_Produto.hidden = false
                    TXT_Valor.placeholder = "Valor Pago em Peso"
                    //TextoLBValor = "valor pago em PESO: "
                default:
                break
            }
            
            
            
           
        }else{
            print("Valor Nil")
            Alerta("Digite um valor para conversão!")
        }
        
    
    }
    

}
