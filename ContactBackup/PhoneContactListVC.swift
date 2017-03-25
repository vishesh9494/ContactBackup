//
//  PhoneContactListVC.swift
//  ContactBackup
//
//

import UIKit
import Contacts

class PhoneContactListVC: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var ContactList_tblView: UITableView!
    var delegate:PhoneContact_Delegate?
    var Contact = Util_Contacts()
    
    var objects = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setMyView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Click_backbtn(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setMyView()
    {
      retrieveContactsWithStore()
    }
    func retrieveContactsWithStore()
    {
           self.objects = Contact.retrieveContactsWithStore()
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.ContactList_tblView.reloadData();
            })
        
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       let cell = tableView.dequeueReusableCell(withIdentifier: "contactList", for: indexPath) as! ContactListCell
        
        let contact = self.objects[indexPath.row]
        if contact.phoneNumbers.count > 0
        {
            let phoneNumber = contact.phoneNumbers[0]
            
            let digit = phoneNumber.value 
             cell.lbl_number.text = digit.stringValue
        }
        cell.lbl_Name.text = contact.givenName
       
        cell.ProfilePick.layer.cornerRadius = cell.ProfilePick.frame.width/2
        cell.ProfilePick.layer.masksToBounds = true
        
        if (contact.imageData != nil)
        {
            cell.ProfilePick.image = UIImage.init(data: contact.imageData!)
            cell.ProfilePick.isUserInteractionEnabled = true            
        }
        else
        {
            cell.ProfilePick.image = UIImage.init(named: "noImg.png")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       delegate?.getDetail!(self.objects[indexPath.row])
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let view1 = UIView()
        view1.backgroundColor = UIColor.white
        return view1
    }
}
