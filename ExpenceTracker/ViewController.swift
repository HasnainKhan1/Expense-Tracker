//
//  ViewController.swift
//  ExpenceTracker
//
//  Created by Hasnain Khan on 4/23/18.
//  Copyright © 2018 Hasnain Khan. All rights reserved.
//

import UIKit
import CoreData



class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var message: UILabel!
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext =
            appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButton(_ sender: UIButton) {
        let email = emailTextField.text
        if (!isValidEmail(testStr: email!))
        {
            message.text = "Invalid Email!"
            return;
        }
        
        let password = passwordTextField.text
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Users")
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email!, password!)
        
        var Users: [NSManagedObject]!
        do {
            Users = try self.managedObjectContext.fetch(request)
        } catch {
            print("getUsers error: \(error)")
        }
        
        for user in Users {
            let e = user.value(forKey: "email") as! String
            let p = user.value(forKey: "password") as! String
            if(e == email && p == password)
            {
                performSegue(withIdentifier: "successfulLoginSegue", sender: self)
            }
            
        }
        message.text = "Username and/or password is incorrect!"

    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
    }

    
    
}



