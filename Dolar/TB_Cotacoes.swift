//
//  TB_Cotacoes.swift
//  Dolar
//
//  Created by Pablo on 9/9/15.
//  Copyright (c) 2015 PrimeSoftware. All rights reserved.
//

import UIKit
import Alamofire

class TB_Cotacoes: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var TB_Cotacoes: UITableView!
    
    var Cotacoes:NSDictionary = NSDictionary()
    var tap = UITapGestureRecognizer()
    var Turismo:NSArray = NSArray()
    var PesoMexico:String = String()
    var Peso_COL:String = String()
    var Dolar:String = String()
    var ValorNovo:String!
    var txtValor:UITextField!
    @IBOutlet weak var IMG_Cotacoes: UIImageView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: "fecharValor:")
        title = "Cotação Dolar"

        
        //COR BACKGROUND
        TB_Cotacoes.backgroundColor = UIColor(rgba: "#3498db")
        view.backgroundColor = UIColor(rgba: "#3498db")
        
        self.navigationController?.navigationBarHidden = false
        Cotacoes = NSDictionary()
        
        if let dest = RetornaNSDefault("Destino") as? String where dest == "mexico" {

            IMG_Cotacoes.image = UIImage(named: "playa_del_carmen")
        }else{
            IMG_Cotacoes.contentMode = UIViewContentMode.ScaleToFill
            IMG_Cotacoes.image = UIImage(named: "san-andres")
        }
        
        //RETORNA DOLAR
        RetornaCotacoes()
        //DOLAR TURISMO
        DolarTurismo()
        //PESO MEXICANO
        PesoMexicano()
        //PESO COLOMBIANO
        PesoCOL()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell_Cotacao", forIndexPath: indexPath) as! Cell_Cotacoes
        
        var moeda:String = String()
        var cotacao:String = String()
        var variacao:String = String()
      
        
    
        
            switch indexPath.row{
            
                
            case 0:
                moeda = "Dolar"
                //cotacao = Cotacoes.objectForKey("dolar")?.valueForKey("cotacao") as! String
                //variacao = Cotacoes.objectForKey("dolar")?.valueForKey("variacao") as! String
                
                //let sinal:String = (variacao as NSString).substringWithRange(NSRange(location: 0,length: 1)) as String
                
                /*if sinal == "+" {
                    cell.LB_Variacao.textColor = UIColor(rgba: "#c0392b")
                }else if sinal == "-" {
                    cell.LB_Variacao.textColor = UIColor(rgba: "#16a085")
                }*/
                if let cot = Dolar as? String {
                    cotacao = Dolar
                }else{
                    cotacao = "0.00"
                }
            
                
            case 1:
                moeda = "Peso Mexicano"
                
                if let cot = PesoMexico as? String{
                    if cot.characters.count > 7 {
                        cotacao = (cot as NSString).substringWithRange(NSRange(location: 0,length: 7)) as String
                    }else{
                        cotacao = cot
                    }
                }else{
                    PesoMexicano()
                }
                
                
            case 2:
                print(Turismo.count)
                if Turismo.count >= 2 {
                    moeda = Turismo[2].valueForKey("name") as! String
                    cotacao = Turismo[2].valueForKey("ask") as! String
                
                }else{
                    moeda = "Dolar Turismo"
                    cotacao = "0.00"
                }
        
            case 3:
                moeda = "Peso Colombiano"
                print("PESO_COL \(Peso_COL)")
                if let cot = Peso_COL as? String {
                    cotacao = cot
                }else{
                    cotacao = "0.00"
                }
                
            case 4:
                cell.LB_Moeda.textColor = UIColor(rgba: "#2c3e50")
                cell.LB_Moeda.text = "Viagem 2016"
                cell.LB_Moeda.textAlignment = .Center
                moeda = "Saldo Atual (R$)"
                if let saldoAux = NSUserDefaults.standardUserDefaults().valueForKey("Saldo"){
                    cotacao = saldoAux as! String
                    variacao = ""
                }else{
                    NSUserDefaults.standardUserDefaults().setValue("0,00", forKey: "Saldo")
                }
                
                
            default:
                break
                
            }
        
        
        
        
        cell.Configure(moeda, cotacao: "R$ \(cotacao)", varicao: variacao)
        

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 4:
            tap.delegate = self
            tap.numberOfTapsRequired = 1
            
            self.view.addGestureRecognizer(tap)
            
            self.TB_Cotacoes.alpha = 0.4
            
            let subview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-60, height: 145))
            subview.center = self.view.center
            subview.backgroundColor = UIColor.whiteColor()
            subview.tag = 2
            
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: subview.frame.size.width-20, height: 20))
            label.text = "Digite o Saldo Atual"
            label.textAlignment = .Center
            label.textColor = UIColor.blackColor()
            label.tag = 3
            
            txtValor = UITextField(frame: CGRect(x: 10, y: 40, width: subview.frame.size.width-20, height: 40))
            txtValor.placeholder = "Ex: 450.00"
            txtValor.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor
            txtValor.layer.borderWidth = 0.3
            txtValor.tag = 4
            
            let bt = UIButton(frame: CGRect(x: 10, y: 100, width: subview.frame.size.width-20, height: 40))
            bt.setTitle("Salvar", forState: .Normal)
            bt.layer.borderColor = UIColor.blackColor().CGColor
            bt.layer.borderWidth = 0.3
            bt.setTitleColor(UIColor.blackColor(), forState: .Normal)
            bt.tag = 5
            
            bt.addTarget(self, action: "SalvaValor", forControlEvents: .TouchUpInside)
            
            
            self.view.addSubview(subview)
            subview.addSubview(label)
            subview.addSubview(txtValor)
            subview.addSubview(bt)
            
        default:
            break
        }
    }
    
    
    func fecharValor(tap:UITapGestureRecognizer){
        self.TB_Cotacoes.alpha = 1.0
        for views in view.subviews{
            if views.tag == 2 {
                views.removeFromSuperview()
            }
        }
        self.view.removeGestureRecognizer(tap)
    }
    
    func SalvaValor(){
        ValorNovo = txtValor.text
       
        self.TB_Cotacoes.alpha = 1.0
        for views in view.subviews{
            if views.tag == 2 {
                views.removeFromSuperview()
            }
        }
        self.view.removeGestureRecognizer(tap)
        
        if let auxVlr = ValorNovo{
            NSUserDefaults.standardUserDefaults().setValue(auxVlr, forKey: "Saldo")
        }
        
        
        self.TB_Cotacoes.reloadData()
        
    }
    
    func RetornaCotacoes(){
        var loader = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loader.hidesWhenStopped = true
        loader.center = view.center
        self.view.addSubview(loader)
        self.TB_Cotacoes.hidden = true
        loader.startAnimating()
        
        
        
        Alamofire.request(.GET, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDBRL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
            .responseJSON{resposta in
                
                if resposta.result.isSuccess {
                    //self.Cotacoes = resposta.result.value as! NSDictionary
                    
                    //var data:String = self.Cotacoes.objectForKey("atualizacao") as! String
                    
                    if let R_DOLAR = resposta.result.value!.objectForKey("query")?.objectForKey("results")?.objectForKey("rate")?.valueForKey("Rate") as? String {
                        self.Dolar = R_DOLAR
                        
                        NSUserDefaults.standardUserDefaults().setObject(R_DOLAR, forKey: "DOLAR")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.TB_Cotacoes.reloadData()
                            loader.stopAnimating()
                            self.TB_Cotacoes.hidden = false
                            
                        })
                    }
                    
                    
                }else{
                    if let cot = NSUserDefaults.standardUserDefaults().valueForKey("DOLAR") as? String {
                        print(cot)
                        //self.Cotacoes = cot
                        self.Dolar = cot
                    }
                    print(resposta.result.error)
                    self.TB_Cotacoes.reloadData()
                    
                   
                    loader.stopAnimating()
                    self.TB_Cotacoes.hidden = false
                }
                
        }
        
    }
    
    
    func DolarTurismo(){
        request(.GET, "http://cotacoes.economia.uol.com.br/cambioJSONChart.html?&cod=BRLT")
        
            .responseJSON{resp in
               
                print(resp.result.value)
                
                if resp.result.isSuccess{
                    self.Turismo = resp.result.value as! NSArray
                    NSUserDefaults.standardUserDefaults().setObject(resp.result.value, forKey: "Turismo")
                    self.TB_Cotacoes.reloadData()
                }else{
                    if let cod = NSUserDefaults.standardUserDefaults().valueForKey("Turismo") as? NSArray {
                         self.Turismo = cod
                         self.TB_Cotacoes.reloadData()
                    }
                    print(resp.result.error)
                }
                
                
        
        }
    }
    
    func PesoMexicano(){
        request(.GET, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22MXNBRL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
        .responseJSON { (resposta) -> Void in
            if resposta.result.isSuccess {
                print(resposta.result.value)
                
                if let R_PMXN = resposta.result.value?.objectForKey("query")?.objectForKey("results")?.objectForKey("rate")?.valueForKey("Rate") as? String {
                    self.PesoMexico = R_PMXN
                    NSUserDefaults.standardUserDefaults().setObject(R_PMXN, forKey: "MXN")
                }
                self.TB_Cotacoes.reloadData()
                
            }else{
                
                if let mxn = NSUserDefaults.standardUserDefaults().valueForKey("MXN") as? String{
                    self.PesoMexico = mxn
                }else{
                    self.PesoMexico = "0.00"
                }
                self.TB_Cotacoes.reloadData()
                print(resposta.result.error)
            }
            
            
        }
    }
    
    /*
    func PesoCOL()->String{
        var COP:String = String()
        request(.GET, "https://api.mercadolibre.com/currency_conversions/search?from=COP&to=BRL")
            .responseJSON{resposta in
                print("COP \(resposta.result.value)")
                if resposta.result.isSuccess {
                    NSUserDefaults.standardUserDefaults().setObject(resposta.result.value, forKey: "COP")
                    
                    if let copRes = resposta.result.value?.valueForKey("ratio") as? NSNumber{
                        COP = "\(copRes)"
                    }
                    
                    print("COP \(COP)")
                    self.TB_Cotacoes.reloadData()
                }else{
                    
                    if let pmxn = NSUserDefaults.standardUserDefaults().valueForKey("COP")!.valueForKey("ratio") as? NSNumber {
                        COP = "\(pmxn)"
                    }
                    print(resposta.result.error)
                    self.TB_Cotacoes.reloadData()
                }
                
        }
        
        return COP
    }*/
    
    
    func PesoCOL()->String{
        var COP:String = String()
        //https://api.mercadolibre.com/currency_conversions/search?from=COP&to=BRL
        request(.GET, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22COPBRL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
            .responseJSON{resposta in
                
                if resposta.result.isSuccess {
                    
                    if let R_COP = resposta.result.value?.objectForKey("query")?.objectForKey("results")?.objectForKey("rate")?.valueForKey("Rate") as? String{
                        NSUserDefaults.standardUserDefaults().setObject(R_COP, forKey: "COP")
                        COP = R_COP
                        self.Peso_COL = COP
                    }
                    
                    print("COP \(COP)")
                    self.self.TB_Cotacoes.reloadData()
                }else{
                    
                    if let pmxn = NSUserDefaults.standardUserDefaults().valueForKey("COP") as? String {
                        COP = pmxn
                        self.Peso_COL = COP
                    }
                    print(resposta.result.error)
                    self.self.TB_Cotacoes.reloadData()
                }
                
        }
        
        return COP
    }
    
    
    @IBAction func Refresh(sender: AnyObject) {
        
        
        RetornaCotacoes()
        DolarTurismo()
        PesoMexicano()
        PesoCOL()
        
    }

 
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
