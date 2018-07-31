//
//  transationsTableTableViewController.swift
//  ExpenceTracker
//
//  Created by Hasnain Khan on 4/26/18.
//  Copyright © 2018 Hasnain Khan. All rights reserved.
//

import UIKit
import CoreData

class transationsTableTableViewController: UITableViewController {
    var nbalance : Double = 0.0
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    let dateFormatter = DateFormatter()
    var transactions: [Transactions] = []
    
    @objc func mainmenu(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromTable", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(mainmenu))
        self.navigationItem.leftBarButtonItem = leftBarButton
        // Uncomment the following line to preserve selection between presentations
         //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        getTransactions()
    }
    
    //fetching transactions from CoreData
    func getTransactions() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Transaction")
        var trans: [NSManagedObject]!
        do {
            trans = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getTransactions error: \(error)")
        }

        for tran in trans {
            let transaction = Transactions()
            transaction.type = tran.value(forKey: "type") as! String
            transaction.date = tran.value(forKey: "date") as! Date
            transaction.amount = tran.value(forKey: "amount") as! Double
            transaction.transID = tran.value(forKey: "transID") as? String
            transactions.append(transaction)
        }
    }
    
    
    //Adding Transactions to core data
    func addTransaction(type: String, date: Date, transID: String, amount: Double) {
        let transaction = NSEntityDescription.insertNewObject(forEntityName:
            "Transaction", into: self.managedObjectContext)
        transaction.setValue(type, forKey: "type")
        transaction.setValue(date, forKey: "date")
        transaction.setValue(amount, forKey: "amount")
        transaction.setValue(transID, forKey: "transID")
        self.appDelegate.saveContext() // In AppDelegate.swift
    }
    
    //Deleting Transactions from core data
    func removeTransactions(transID: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Transaction")
        fetchRequest.predicate = NSPredicate(format: "transID == %@", transID)
        var transaction: [NSManagedObject]!
        do {
            transaction = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("removeTransaction error: \(error)")
        }
        for t in transaction {
            self.managedObjectContext.delete(t)
        }
        self.appDelegate.saveContext() // In AppDelegate.swift
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transactions.count
    }
    


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! transactionCellTableViewCell
        let trans = transactions[indexPath.row]
        let date = dateFormatter.string(from: trans.date)
        let amount = trans.amount
        cell.amountCell.text = "$\(amount)"
        cell.dateCell.text = "\(date)"
        cell.typeLabel.text = trans.type
        if cell.typeLabel.text == "Expense" || cell.typeLabel.text == "expense"
        {
            cell.backgroundColor = UIColor.red
        }
        else {cell.backgroundColor = UIColor.blue}
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let id = transactions[indexPath.row].transID{
                removeTransactions(transID: id)
            }
            transactions.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindFromAdd(sender: UIStoryboardSegue)
    {
        let addTransactionVC = sender.source as! AddUIViewController
        if !addTransactionVC.cancelled {
            let transaction = Transactions()
            let amount = NSString(string: addTransactionVC.amountTextField.text!)
            transaction.amount = amount.doubleValue
            transaction.date = dateFormatter.date(from: addTransactionVC.dateTextField.text!)!
            transaction.type = addTransactionVC.typeTextField.text!
            transaction.transID = addTransactionVC.id?.uuidString
            transactions.append(transaction)
            addTransaction(type: transaction.type, date: transaction.date, transID: transaction.transID!, amount: transaction.amount)
            if(transaction.type == "Salary" || transaction.type == "salary")
            {
                nbalance = nbalance + transaction.amount
            }
            else{
                nbalance = nbalance - transaction.amount
            }
            self.tableView.reloadData()
        }
    }

}
