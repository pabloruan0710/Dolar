//
//  TB_Roteiros.swift
//  Dolar
//
//  Created by Pablo on 10/26/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import UIKit

class TB_Roteiros: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TB_Roteiros: UITableView!
    
    var Roteiros:NSMutableArray = NSMutableArray()
    
    var Valor:String!
    var Observacao:String!
    var TituloDest:String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //COR BACKGROUND
        title = "Roteiros"
        
        TB_Roteiros.backgroundColor = UIColor(rgba: "#ecf0f1")
        view.backgroundColor = UIColor(rgba: "#ecf0f1")
        
        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().statusBarHidden = false
        
        /*
        Roteiros.addObject(["titulo":"Aquarium","status":0])
        Roteiros.addObject(["titulo":"Haynes Cay","status":0])
        Roteiros.addObject(["titulo":"Cayo Bolivar","status":1])
        Roteiros.addObject(["titulo":"Rocky Cay","status":0])
        Roteiros.addObject(["titulo":"Jonhy Cay","status":1])
        Roteiros.addObject(["titulo":"El Acuario","status":0])
        */
        
        //NSUserDefaults.standardUserDefaults().setObject(Roteiros, forKey: "Roteiros")
        
        if let Ret = NSUserDefaults.standardUserDefaults().valueForKey("Roteiros") {
            Roteiros.addObjectsFromArray(Ret as! [AnyObject])
            Roteiros.sortUsingDescriptors([NSSortDescriptor(key: "status", ascending: false)])
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func viewWillAppear(animated: Bool) {
        //Roteiros.sortUsingDescriptors([NSSortDescriptor(key: "status", ascending: false)])
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Roteiros.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Roteiros_Cell", forIndexPath: indexPath) as! TB_Roteiros_Cell

        // Configure the cell...
        cell.LB_Titulo.text = Roteiros[indexPath.row].valueForKey("titulo") as? String
        
        //VAI IMPERDIVEL
        if let status = Roteiros[indexPath.row].valueForKey("status") as? Int where status == 1{
            cell.BT_Vamos.setImage(UIImage(named: "like_yes"), forState: UIControlState.Normal)
            cell.LB_Status.text = "Imperdível"
            cell.LB_Status.textColor = UIColor(rgba: "#8e44ad")
            cell.IMG_Icone.image = UIImage(named: "roteiros")
            cell.LB_Titulo.textColor = UIColor(rgba: "#2c3e50")
            cell.LB_Cor.backgroundColor = UIColor(rgba: "#e74c3c")
        }
        //NAO VAI ou TALVEZ
        else{
            cell.BT_Vamos.setImage(UIImage(named: "like"), forState: UIControlState.Normal)
            cell.BT_Vamos.setImage(UIImage(named: "like_yes"), forState: UIControlState.Selected)
            cell.LB_Status.text = "A Definir"
            cell.LB_Status.textColor = UIColor(rgba: "#95a5a6")
            cell.IMG_Icone.image = UIImage(named: "roteiros_no")
            cell.LB_Titulo.textColor = UIColor(rgba: "#95a5a6")
            cell.LB_Cor.backgroundColor = UIColor(rgba: "#95a5a6")
        }
        
        cell.BT_Vamos.imageEdgeInsets = UIEdgeInsetsMake(18, 10, 0, 10)
        cell.BT_Vamos.imageView?.contentMode = UIViewContentMode.ScaleToFill
        cell.BT_Vamos.tag = indexPath.row
        cell.BT_Vamos.addTarget(self, action: "MarcarImperdivel:", forControlEvents: UIControlEvents.TouchUpInside)

        return cell
    }
    
    
    func MarcarImperdivel(like:UIButton){
        
        var temp = Roteiros.mutableCopy() as! NSMutableArray
        
        if let Status = Roteiros[like.tag].valueForKey("status") as? Int, let titulo = Roteiros[like.tag].valueForKey("titulo") as? String {
            
            temp.removeObjectAtIndex(like.tag)
            
            if Status == 1 {
                temp.addObject(["titulo":"\(titulo)","status":0])
            }else{
                temp.addObject(["titulo":"\(titulo)","status":1])
            }
            temp.sortUsingDescriptors([NSSortDescriptor(key: "status", ascending: false)])
            
            NSUserDefaults.standardUserDefaults().setObject(temp, forKey: "Roteiros")
            
            Roteiros = temp
            TB_Roteiros.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    @IBAction func Novo_roteiro(sender: AnyObject) {
        
        let nib = NSBundle.mainBundle().loadNibNamed("NovoRoteiro", owner: nil, options: nil)[0] as! Novo_Roteiro
        nib.frame = CGRectMake(20, 80, self.view.bounds.width-40, self.view.bounds.height-320)
        nib.tag = 999
        
        nib.TXT_DestinoNome.clipsToBounds = true
        nib.TXT_DestinoNome.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.6).CGColor
        nib.TXT_DestinoNome.layer.borderWidth = 0.3
        nib.TXT_DestinoNome.layer.cornerRadius = 3
        
        nib.TXT_ValorMedio.clipsToBounds = true
        nib.TXT_ValorMedio.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.6).CGColor
        nib.TXT_ValorMedio.layer.borderWidth = 0.3
        nib.TXT_ValorMedio.layer.cornerRadius = 3
        
        nib.TXT_Observacoes.clipsToBounds = true
        nib.TXT_Observacoes.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.6).CGColor
        nib.TXT_Observacoes.layer.borderWidth = 0.3
        nib.TXT_Observacoes.layer.cornerRadius = 3
        
        nib.TXT_Observacoes.contentOffset = CGPointMake(0, nib.TXT_Observacoes.contentSize.height - nib.TXT_Observacoes.frame.size.height);
        
        nib.BT_Salvar.addTarget(self, action: "Salvar", forControlEvents: UIControlEvents.TouchUpInside)
  
        /*nib.BT_Like.imageEdgeInsets = UIEdgeInsetsMake(18, 10, 0, 10)
          nib.BT_Like.setImage(UIImage(named: "like"), forState: UIControlState.Normal)
          nib.BT_Like.imageView?.contentMode = UIViewContentMode.ScaleToFill*/
        
        Valor = nib.TXT_ValorMedio.text
        Observacao = nib.TXT_Observacoes.text
        TituloDest = nib.TXT_DestinoNome.text
        
        self.view.layer.opacity = 0.2
        self.navigationController?.view.addSubview(nib)
    }
    
    func Salvar(){
        self.view.layer.opacity = 1
        
        for views in (self.navigationController?.view.subviews)! {
            if views.tag == 999 {
                views.removeFromSuperview()
            }
        }
        
        
        
        var temp = Roteiros.mutableCopy() as! NSMutableArray
            temp.addObject(["titulo":"\(TituloDest)",
                            "status":0,
                            "observacao":"\(Observacao)",
                            "valor":"\(Valor)"])
        NSUserDefaults.standardUserDefaults().setObject(temp, forKey: "Roteiros")
        
        print(NSUserDefaults.standardUserDefaults().valueForKey("Roteiros"))
        
        if let Ret = NSUserDefaults.standardUserDefaults().valueForKey("Roteiros") as? NSArray {
            Roteiros = Ret as! NSMutableArray
            Roteiros.sortUsingDescriptors([NSSortDescriptor(key: "status", ascending: false)])
        }else{
            Roteiros = temp
        }
       
        print(Roteiros)
    }
   
}
