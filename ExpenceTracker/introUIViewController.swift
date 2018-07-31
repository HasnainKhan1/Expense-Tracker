//
//  introUIViewController.swift
//  ExpenceTracker
//
//  Created by Hasnain Khan on 4/26/18.
//  Copyright © 2018 Hasnain Khan. All rights reserved.
//

import UIKit
import CoreData

class introUIViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var Balance : Double = 0.0
    @IBOutlet weak var balanceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Balance")
        var balance: [NSManagedObject]!
        do {
            balance = try self.managedObjectContext.fetch(request)
        } catch {
            print("getBalance error: \(error)")
        }
        if(isEmpty)
        {
            initBalance()
        }
        else{
            for b in balance {
                Balance = b.value(forKey: "balance") as! Double
                balanceLabel.text = "$\(Balance)";
            }
        }
        
    }
    
    
    var isEmpty : Bool {
        do{
            let request = NSFetchRequest<NSManagedObject>(entityName: "Balance")
            let count  = try managedObjectContext.count(for: request)
            return count == 0 ? true : false
        }catch{
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewTransactionButton(_ sender: UIButton) {
    }
    
    func initBalance() {
        let balance = NSEntityDescription.insertNewObject(forEntityName:
            "Balance", into: self.managedObjectContext)
        Balance = 1000.00
        balance.setValue(Balance, forKey: "balance")
        self.appDelegate.saveContext() // In AppDelegate.swift
        balanceLabel.text = "$1000.00";

    }
    
    override func viewWillAppear(_ animated: Bool) {
        balanceLabel.text = "$\(Balance)"
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showTableViewController")
        {
            let detailVC = segue.destination as! transationsTableTableViewController
            detailVC.nbalance = Balance
        }
    }
    
    @IBAction func unwindFromTable(sender: UIStoryboardSegue)
    {
        let addTransactionVC = sender.source as! transationsTableTableViewController
        Balance = addTransactionVC.nbalance
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Balance")
        var balance: [NSManagedObject]!
        do {
            balance = try self.managedObjectContext.fetch(request)
        } catch {
            print("getBalance error: \(error)")
        }
        for b in balance {
            b.setValue(Balance, forKey: "balance")
        }
        self.appDelegate.saveContext() // In AppDelegate.swift
    }
    

}
