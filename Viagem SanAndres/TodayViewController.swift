//
//  TodayViewController.swift
//  Viagem SanAndres
//
//  Created by Pablo on 10/29/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TB_Moedas: UITableView!
    
    var marginIndicator = UIView()
    var defaultLeftInset: CGFloat = 10
  
    var Moedas:NSMutableArray = NSMutableArray()
    
    var ValorDigitado:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PREFERENCES
//        let sharedPref = NSUserDefaults(suiteName: "group.ViagemSanAndres")
//        let cop = sharedPref!.objectForKey("TCOP") as! String
//        let copReal = 1/Int(cop)!
//        let mxn = sharedPref?.objectForKey("TMXN") as! String
//        let dolar = sharedPref?.objectForKey("TDOLAR") as! String
//        let turismo = sharedPref?.objectForKey("TTurismo") as! String
//        
//        Moedas.addObject(["moeda":"DOLAR COMERCIAL","valor":"\(dolar)"])
//        Moedas.addObject(["moeda":"DOLAR TURISMO","valor":"\(turismo)"])
//        Moedas.addObject(["moeda":"PESO MEXICANO","valor":"\(mxn)"])
//        Moedas.addObject(["moeda":"PESO COLOMBIANO","valor":"\(cop)"])
//        Moedas.addObject(["moeda":"REAL PARA PESO","valor":"\(copReal)"])
//       
        self.preferredContentSize = CGSizeMake(self.preferredContentSize.width, CGFloat(Moedas.count*44))
        
        self.TB_Moedas.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        
        //Moedas.removeAllObjects()
        //PREFERENCES
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
        
            let sharedPref = NSUserDefaults(suiteName: "group.ViagemSanAndres")
            let cop = sharedPref!.objectForKey("TCOP") as! String
            let copReal = 1/Int(cop)!
            let mxn = sharedPref?.objectForKey("TMXN") as! String
            let dolar = sharedPref?.objectForKey("TDOLAR") as! String
            let turismo = sharedPref?.objectForKey("TTurismo") as! String
            
            self.Moedas.addObject(["moeda":"DOLAR COMERCIAL","valor":"\(dolar)"])
            self.Moedas.addObject(["moeda":"DOLAR TURISMO","valor":"\(turismo)"])
            self.Moedas.addObject(["moeda":"PESO MEXICANO","valor":"\(mxn)"])
            self.Moedas.addObject(["moeda":"PESO COLOMBIANO","valor":"\(cop)"])
            self.Moedas.addObject(["moeda":"REAL PARA PESO","valor":"\(copReal)"])
            
            self.TB_Moedas.reloadData()
        }
        //MARGEM
        marginIndicator.frame = CGRectMake(0, 0, 10, view.frame.size.height)
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(var defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        defaultLeftInset = defaultMarginInsets.left
        
        defaultMarginInsets.left = 10
        return defaultMarginInsets
      
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Moedas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Today_Cell") as! Today_Cell
        
        
        
        
        cell.LB_Moeda.text = Moedas[indexPath.row].valueForKey("moeda") as? String
        cell.LB_Valor.text = Moedas[indexPath.row].valueForKey("valor") as? String
        
        
        return cell
    }
    
    
    
    
}
