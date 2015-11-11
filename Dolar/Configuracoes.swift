//
//  Configuracoes.swift
//  Dolar
//
//  Created by Pablo on 10/10/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import UIKit
import Alamofire

class Configuracoes: UITableViewController {

    
    @IBOutlet var TB_Config: UITableView!
    @IBOutlet weak var SW_Mexico: UISwitch!
    @IBOutlet weak var SW_Colombia: UISwitch!
    @IBOutlet weak var TXT_ValorPMXN: UITextField!
    @IBOutlet weak var TXT_ValorPCOP: UITextField!
    @IBOutlet weak var TXT_ValorDolar: UITextField!
    @IBOutlet weak var TXT_ValorDtoP: UITextField!
    
    @IBOutlet weak var SW_PMXN: UISwitch!
    @IBOutlet weak var SW_PCOP: UISwitch!
    @IBOutlet weak var SW_Dolar: UISwitch!
    @IBOutlet weak var SW_DolarToPeso: UISwitch!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salvar", style: UIBarButtonItemStyle.Done, target: self, action: "Salvar")
    
    }
    
    override func viewWillAppear(animated: Bool) {
        if let pmxn = RetornaNSDefault("PMXN") as? String {
            TXT_ValorPMXN.text = pmxn
        }
        
        if let pcop = RetornaNSDefault("PCOP") as? String {
            TXT_ValorPCOP.text = pcop
        }
        
        if let pdolar = RetornaNSDefault("PDOLAR") as? String {
            TXT_ValorDolar.text = pdolar
        }
        
        if let pdolartopeso = RetornaNSDefault("DOLARPESO") as? String {
            TXT_ValorDtoP.text = pdolartopeso
        }
        
        //VERIFICA SWITCH ON
        if let ON_ = RetornaNSDefault("UsarPMXN") as? Bool where ON_ == true {
            SW_PMXN.setOn(true, animated: false)
        }
        
        if let ON_ = RetornaNSDefault("UsarPCOP") as? Bool where ON_ == true {
            SW_PCOP.setOn(true, animated: false)
        }
        
        if let ON_ = RetornaNSDefault("UsarDOLAR") as? Bool where ON_ == true {
            SW_Dolar.setOn(true, animated: false)
        }
        
        if let ON_ = RetornaNSDefault("UsarDOLARPESO") as? Bool where ON_ == true {
            SW_DolarToPeso.setOn(true, animated: false)
        }
        
        if let ON_ = RetornaNSDefault("Destino") as? String where ON_ == "mexico" {
            SW_Mexico.setOn(true, animated: true)
            SW_Colombia.setOn(false, animated: true)
        }else{
            SW_Colombia.setOn(true, animated: true)
            SW_Mexico.setOn(false, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func Salvar(){
        print("Salvando.......")
        
        //salvar destino
        if SW_Mexico.on {
            NSUserDefaults.standardUserDefaults().setValue("mexico", forKey: "Destino")
        }else{
            NSUserDefaults.standardUserDefaults().setValue("colombia", forKey: "Destino")
        }
        
        //salvar peso mexicano
        if let PMXN = TXT_ValorPMXN.text where PMXN != "" {
            NSUserDefaults.standardUserDefaults().setValue(PMXN, forKey: "PMXN")
        }
        
        //salvar peso colombiano
        if let PCOP = TXT_ValorPCOP.text where PCOP != ""{
            NSUserDefaults.standardUserDefaults().setValue(PCOP, forKey: "PCOP")
        }
        
        //salvar dolar
        if let DLAR = TXT_ValorDolar.text where DLAR != "" {
            NSUserDefaults.standardUserDefaults().setValue(DLAR, forKey: "PDOLAR")
        }
        
        //Salva Dolar para Peso Cotação Atual
        if let DLARPESO = TXT_ValorDtoP.text where DLARPESO != "" {
            NSUserDefaults.standardUserDefaults().setValue(DLARPESO, forKey: "DOLARPESO")
        }
        
        //ativar ou desativar cambios manual
        if SW_PMXN.on {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "UsarPMXN")
        }else{
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "UsarPMXN")
        }
        
        if SW_PCOP.on {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "UsarPCOP")
        }else{
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "UsarPCOP")
        }
        
        if SW_Dolar.on {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "UsarDOLAR")
        }else{
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "UsarDOLAR")
        }
        
        if SW_DolarToPeso.on {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "UsarDOLARPESO")
        }else{
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "UsarDOLARPESO")
        }
        
        Alerta("Configurações Salvas com sucesso!")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Destino da Viagem"
        }else{
            return "Valores de Câmbios"
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor.clearColor()
        
        var label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        
        if section == 0 {
            label.text =  "Destino da Viagem"
        }else{
            label.text =  "Valores de Câmbios"
        }
        
       
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "Helvetica", size: 20)
        label.textAlignment = NSTextAlignment.Center

        headerView.addSubview(label)
        
        return headerView

    }
    
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Table view data source

   
    
    
    @IBAction func SW_Mexico(sender: AnyObject) {
        
        SW_PCOP.enabled = true
        SW_PMXN.enabled = true
        
        if SW_Mexico.on {
            SW_Colombia.setOn(false, animated: true)
            SW_PCOP.enabled = false
            SW_PCOP.setOn(false, animated: true)
        }else{
            SW_PCOP.enabled = true
            SW_Colombia.setOn(true, animated: true)
        }
    }
    
   
    
    @IBAction func SW_Colombia(sender: AnyObject) {
        
        SW_PCOP.enabled = true
        SW_PMXN.enabled = true
        
        if SW_Colombia.on {
            SW_Mexico.setOn(false, animated: true)
            SW_PMXN.enabled = false
            SW_PMXN.setOn(false, animated: true)
        }else{
            SW_PMXN.enabled = true
            SW_Mexico.setOn(true, animated: true)
        }
        
    }
   
    @IBAction func SW_PesoMexicano(sender: AnyObject) {
        if SW_PMXN.on {
            SW_PCOP.enabled = false
        }else{
            SW_PCOP.enabled = true
        }
    }
    
    @IBAction func SW_PesoColombiano(sender: AnyObject) {
        if SW_PCOP.on {
            SW_PMXN.enabled = false
        }else{
            SW_PMXN.enabled = true
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
