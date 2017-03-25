//
//  ViewController.swift
//  ContactBackup
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txt_name: UITextField!
    
    var manager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionbtn(_ sender: AnyObject)
    {
        if manager.CreateDatabse()
        {
            let p1 = Person_Model()
            p1.FirstName = self.txt_name.text!
            let models = NSMutableArray()
            models.add(p1)
            if manager.Insert(models)
            {
                print("Data inserted")
            }
            else
            {
                print("Data not inserted")
            }
            
        }

    }

}

