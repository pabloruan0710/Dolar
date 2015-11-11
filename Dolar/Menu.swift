//
//  Menu.swift
//  Dolar
//
//  Created by Pablo on 10/9/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import UIKit
import Alamofire

class Menu: UITableViewController {

    @IBOutlet var TB_Menu: UITableView!
    
    var Menus = ["Conversão Moeda","Cotação","Roteiros","Gastos","Hospedagem","Passagens","Anotações", "Dicas", "Datas","Configurações"]
    var Imagens = ["conversao","cotacao","roteiro","gastos","hospedagem","passagens","anotacoes","dicas","datas","config"]
    var CorMenus : NSArray = NSArray()
    
    var sharedPreference:NSUserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharedPreference = NSUserDefaults(suiteName: "group.ViagemSanAndres")
        
        CorMenus = CoresMenu()
        
        TB_Menu.backgroundColor = UIColor(rgba: "#1abc9c")
        
        self.navigationController?.NavigationBarCor(navigationController!)
        
        PesoCOL()
        PesoMexicano()
        DolarTurismo()
        DolarComercial()
        
        /*let PesoString:String = "Teste"
        sharedPreference?.setValue(PesoString, forKey: "Today")
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = true
        self.navigationController?.navigationBarHidden = true
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Menus.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Menus_Cell", forIndexPath: indexPath) as! Menu_Cell
        
        cell.ConfiguraMenus(Menus[indexPath.row], ImagemMenu: Imagens[indexPath.row])
        cell.backgroundColor = UIColor(rgba: CorMenus[indexPath.row] as! String)

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var story = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.row {
        case 0:
            var dest:TB_Conversao!
            dest = story.instantiateViewControllerWithIdentifier("Conversao") as! TB_Conversao
            self.navigationController?.pushViewController(dest, animated: true)
            
        case 1:
            var dest:TB_Cotacoes!
            dest = story.instantiateViewControllerWithIdentifier("cotacoes") as! TB_Cotacoes
            self.navigationController?.pushViewController(dest, animated: true)
        case 2:
            var dest:TB_Roteiros!
            dest = story.instantiateViewControllerWithIdentifier("Roteiros") as! TB_Roteiros
            self.navigationController?.pushViewController(dest, animated: true)
        case 3:
            print("")
        case 4:
            print("")
        case 5:
            print("")
        case 6:
            print("")
        case 7:
            print("")
        case 8:
            print("")
        case 9:
            var dest:Configuracoes!
            dest = story.instantiateViewControllerWithIdentifier("Configuracoes") as! Configuracoes
            self.navigationController?.pushViewController(dest, animated: true)
        default:
            break
        }
    }
    
    
    
    
    
    func DolarComercial(){

        Alamofire.request(.GET, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDBRL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
            .responseJSON{resposta in
                
                if resposta.result.isSuccess {
                 if let R_DOLAR = resposta.result.value!.objectForKey("query")?.objectForKey("results")?.objectForKey("rate")?.valueForKey("Rate") as? String {
                        NSUserDefaults.standardUserDefaults().setObject(R_DOLAR, forKey: "DOLAR")
                    }
                }
        }
        
        let mxnP = NSUserDefaults.standardUserDefaults().valueForKey("DOLAR")
        
        if let mxn = NSUserDefaults.standardUserDefaults().valueForKey("TDOLAR") {
            
            sharedPreference!.setValue(mxn, forKey: "TDOLAR")
            
            sharedPreference!.synchronize()
        }
        
    }
    
    
    func DolarTurismo(){
        request(.GET, "http://cotacoes.economia.uol.com.br/cambioJSONChart.html?&cod=BRLT")
            
            .responseJSON{resp in
                if resp.result.isSuccess{
                    NSUserDefaults.standardUserDefaults().setObject(resp.result.value, forKey: "Turismo")
                }
                
        }
        
        let mxnP = NSUserDefaults.standardUserDefaults().valueForKey("Turismo")
        
        if let mxn = NSUserDefaults.standardUserDefaults().valueForKey("Turismo") {
           
            sharedPreference!.setValue(mxn, forKey: "TTurismo")
            
            sharedPreference!.synchronize()
        }
    }
    
    func PesoMexicano(){
        request(.GET, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22MXNBRL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
            .responseJSON { (resposta) -> Void in
                if resposta.result.isSuccess {
                    if let R_PMXN = resposta.result.value?.objectForKey("query")?.objectForKey("results")?.objectForKey("rate")?.valueForKey("Rate") as? String {
                        NSUserDefaults.standardUserDefaults().setObject(R_PMXN, forKey: "MXN")
                    }
                }
                
        }
        
        let mxnP = NSUserDefaults.standardUserDefaults().valueForKey("MXN")
        
        if let mxn = NSUserDefaults.standardUserDefaults().valueForKey("MXN") {
            
            sharedPreference!.setValue(mxn, forKey: "TMXN")
            
            sharedPreference!.synchronize()
        }
    }
    
    
    func PesoCOL(){
      
        //https://api.mercadolibre.com/currency_conversions/search?from=COP&to=BRL
        request(.GET, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22COPBRL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
            .responseJSON{resposta in
                
                if resposta.result.isSuccess {
                    
                    if let R_COP = resposta.result.value?.objectForKey("query")?.objectForKey("results")?.objectForKey("rate")?.valueForKey("Rate") as? String{
                        NSUserDefaults.standardUserDefaults().setObject(R_COP, forKey: "COP")
                       
                    }
                }else{
                    
                }
        }
        
        let realCop = NSUserDefaults.standardUserDefaults().valueForKey("PCOP")
        
        if let cop = NSUserDefaults.standardUserDefaults().valueForKey("COP") {
            
            sharedPreference!.setValue(cop, forKey: "TCOP")
            sharedPreference!.setValue(realCop, forKey: "TPCOP")
            sharedPreference!.synchronize()
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
