//
//  RegisterViewController.swift
//  ExpenceTracker
//
//  Created by Hasnain Khan on 4/23/18.
//  Copyright © 2018 Hasnain Khan. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passTextFeild: UITextField!
    @IBOutlet weak var repeatPassTextField: UITextField!
    @IBOutlet weak var message: UILabel!
    
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
        let email = emailTextFeild.text
        let pass = passTextFeild.text
        let repeatPass = repeatPassTextField.text
        
        //check for empty fields
        if((email?.isEmpty)! || (pass?.isEmpty)! || (repeatPass?.isEmpty)!)
        {
            message.text = "All fields are required!"
            return;
        }
        //check for invalid email
        if (!isValidEmail(testStr: email!))
        {
            message.text = "Invalid Email!"
            return;
        }
        
        //check if passwords match
        if(pass != repeatPass)
        {
            message.text = "Passwords do not match!"
            return;
        }
        
        addUser(email: email!, password: pass!)
        //display alert message
        let myAlert = UIAlertController(title: "Alert", message: "Registration is successfull. Thank You!", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        myAlert.addAction(okAction)
        self.present(myAlert, animated:true, completion:nil)
    }
    
    func addUser(email:String, password:String) {
        let user = NSEntityDescription.insertNewObject(forEntityName:
            "Users", into: self.managedObjectContext)
        user.setValue(email, forKey: "email")
        user.setValue(password, forKey: "password")
        self.appDelegate.saveContext() // In AppDelegate.swift
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
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
