//
//  AddUIViewController.swift
//  ExpenceTracker
//
//  Created by Hasnain Khan on 4/27/18.
//  Copyright © 2018 Hasnain Khan. All rights reserved.
//

import UIKit

class AddUIViewController: UIViewController, UITextFieldDelegate {

    var cancelled: Bool = true
    var id : UUID?
    let dateFormatter = DateFormatter()
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!


    @IBAction func clearButton(_ sender: UIButton) {
        typeTextField.text = ""
        dateTextField.text = ""
        amountTextField.text = ""
    }
    @objc func cancelButton(_ sender: UIBarButtonItem) {
        cancelled = true
        performSegue(withIdentifier: "unwindFromAddUI", sender: nil)
    }
    
    @objc func addButton(_ sender: UIBarButtonItem) {
        if validInputs() {
            cancelled = false
            id = UUID.init()
            performSegue(withIdentifier: "unwindFromAddUI", sender: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButton))
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "MM/dd/yyyy"
        typeTextField.delegate = self
        dateTextField.delegate = self
        amountTextField.delegate = self
        amountTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validInputs () -> Bool {
        if typeTextField.text!.isEmpty {
            entryAlert("Missing destination")
            return false
        }
        if (dateFormatter.date(from: dateTextField.text!) == nil) {
            entryAlert("Invalid start date")
            return false
        }
        if amountTextField.text!.isEmpty {
            entryAlert("Invalid end date")
            return false
        }
        // Maybe check for proper dates and startDate <= endDate
        return true
    }
    
    func entryAlert(_ message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
