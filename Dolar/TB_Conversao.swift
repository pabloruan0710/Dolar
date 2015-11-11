//
//  TB_Conversao.swift
//  Dolar
//
//  Created by Pablo on 10/9/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import UIKit
import Alamofire

var SelecionadaCalculo:Int = Int()
var DolarComercial:String = String()
var PesoMexicano:String = String()

class TB_Conversao: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate {
  
    @IBOutlet weak var TB_Conversao: UITableView!
    var Selecionada:Int!
    var Cores:NSArray = ["#34495E","#34495E","#2980b9","#2980b9","#e67e22","#e67e22","#2ecc71","#c0392b","#1abc9c","#1abc9c"]
    var tap:UITapGestureRecognizer = UITapGestureRecognizer()
    var TextoLBValor:String!
    
    
    var ConversaoTipos = ["REAL para PESO",
                            "PESO para REAL",
                            "REAL para DOLAR",
                            "DOLAR para REAL",
                            "PESO para DOLAR",
                            "DOLAR para PESO",
                            "TROCO EM PESO",
                            "TROCO EM DOLAR"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cores = CoresMenu()
        
        self.navigationController?.navigationBarHidden = false
        
        title = "Conversões de Moeda"
        
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        tap.addTarget(self, action: "CloseTeclado")
        
        if let dest = RetornaNSDefault("Destino") as? String {
            if dest == "mexico" {
                PesoMexicano = PesoMXN()
            }else if dest == "colombia" {
                PesoMexicano = PesoCOL()
            }
        }else{
            PesoMexicano = PesoMXN()
            Alerta("Destino Padrão selecionado! Playa del Carmem. Pesos Mexicano.")
        }
        
        DolarComercial = Dolar()
        
        if let cotacMXN = RetornaNSDefault("UsarPMXN") as? Bool where cotacMXN == true {
            if let R_PMXN = RetornaNSDefault("PMXN") as? String where R_PMXN != "" {
                PesoMexicano = R_PMXN
            }
        }
        
        if let cotacMXN = RetornaNSDefault("UsarPCOP") as? Bool where cotacMXN == true {
            if let R_PMXN = RetornaNSDefault("PCOP") as? String where R_PMXN != "" {
                PesoMexicano = R_PMXN
            }
        }
        
        if let cotacMXN = RetornaNSDefault("UsarDOLAR") as? Bool where cotacMXN == true {
            if let R_PMXN = RetornaNSDefault("PDOLAR") as? String where R_PMXN != "" {
                DolarComercial = R_PMXN
            }
        }
        
        if let cotacMXN = RetornaNSDefault("UsarDOLARPESO") as? Bool where cotacMXN == true {
            if let R_PMXN = RetornaNSDefault("DOLARPESO") as? String where R_PMXN != "" {
                DolarComercial = R_PMXN
            }
        }
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    func CloseTeclado(){
        self.view.endEditing(true)
        self.view.removeGestureRecognizer(tap)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.view.addGestureRecognizer(tap)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }
        else if section == 1 {
            return ConversaoTipos.count
        }else{
            return 1
        }
        
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:TB_Conversao_Cell!
        
        //BOTAO RESETAR
        if indexPath.section == 0 {
            
            cell = tableView.dequeueReusableCellWithIdentifier("Conversao_Reset", forIndexPath: indexPath) as! TB_Conversao_Cell
            cell.BT_Reset.addTarget(self, action: "AlteraMoedas", forControlEvents: UIControlEvents.TouchUpInside)
            
            if let sec = Selecionada {
                if indexPath.row == 0 {
                    cell.BT_Reset.hidden = false
                    cell.hidden = false
                }else{
                    cell.BT_Reset.hidden = true
                    cell.hidden = true
                }
                
            }else{
                cell.hidden = true
            }
            
        }
        //TIPOS DE CONVERSAO
        else if indexPath.section == 1 {
            
            cell = tableView.dequeueReusableCellWithIdentifier("Conversao_tipo", forIndexPath: indexPath) as! TB_Conversao_Cell
            cell.BT_Selecionado.setTitle("\u{f096}", forState: UIControlState.Normal)
            cell.BT_Selecionado.tag = indexPath.row
            
            print("TAG \(cell.BT_Selecionado.tag) -> \(ConversaoTipos[indexPath.row])")
            
            if let sec = Selecionada {
                
                if indexPath.row == sec {
                    cell.hidden = false
                    cell.BT_Selecionado.setTitle("\u{f046}", forState: UIControlState.Normal)
                }else{
                    cell.hidden = true
                }
                
                
            }else{
                cell.hidden = false
            }
            
            
            cell.TiposConversao(ConversaoTipos[indexPath.row], Cor: Cores[indexPath.row] as! String)
            
        }
        //RESULTADOS
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("Conversao_resultado", forIndexPath: indexPath) as! TB_Conversao_Cell
            
            //cell.BT_Calcular.addTarget(self, action: "Converter:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.ResultadoConversao("Resultado", Valor: "0.00")
            cell.VlrEmPESO.setTitle("\u{f096}", forState: .Normal)
            
            if let valrEm = TextoLBValor {
                cell.LB_ValorEm.text = valrEm
                
            }else{
                cell.LB_ValorEm.text = "Selecione o tipo de Conversão acima"
            }
            
            if cell.TXT_Valor.text?.characters.count > 1 {
                cell.BT_Calcular.restorationIdentifier = cell.TXT_Valor.text
            }
            
            
        }
        

        // Configure the cell...

        return cell
    }
    
    //HEIGHT FOR ROW
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //BT RESETAR
        if indexPath.section == 0{
           
            var retorno:CGFloat = 55
            
            if let sec = Selecionada {
                 retorno = 55
            }else{
                retorno = 0
            }
            return retorno
        }
        //TIPOS CONVERSAO
        else if indexPath.section == 1 {
            var retorno:CGFloat = 55
            
                if let sec = Selecionada {
                    if indexPath.row == sec {
                        retorno =  55
                    }else{
                        retorno = 0
                    }
                }
                
                return retorno
        }else{
           
            return 210
        }
        
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 4
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        if indexPath.section == 0 {
            Selecionada = nil
            TB_Conversao.reloadData()
            
            
        }
        else if indexPath.section == 1{
            Selecionada = indexPath.row
            
            switch indexPath.row {
            case 0:
                TextoLBValor = "Digite o valor em REAL: "
            case 1:
                TextoLBValor = "Digite o valor em PESO MXN: "
            case 2:
                TextoLBValor = "Digite o valor em REAL: "
            case 3:
                TextoLBValor = "Digite o valor em DOLAR: "
            case 4:
                TextoLBValor = "Digite o valor em PESO: "
            case 5:
                TextoLBValor = "Digite o valor em DOLAR: "
            case 6:
                TextoLBValor = "Valor pago em DOLAR: "
            case 7:
                TextoLBValor = "valor pago em PESO: "
            default:
                break
            }
            
            SelecionadaCalculo = Selecionada
            
            TB_Conversao.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    //Botão Altera Moedas
    func AlteraMoedas() {
        Selecionada = nil
        TextoLBValor = "Selecione o tipo de Conversão acima"
        TB_Conversao.reloadData()
    }
    
    
    func Converter(valor:UIButton){
        self.TB_Conversao.reloadData()
        print("CONVERTER ********")
        print(valor.restorationIdentifier)
    }
    
        
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return truem
    WF-FN-HTq-view-QgP-5U-pVu
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
