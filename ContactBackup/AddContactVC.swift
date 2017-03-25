//
//  AddContactVC.swift
//  ContactBackup
//
//

import UIKit
import Contacts
import ContactsUI

@objc protocol PhoneContact_Delegate : class
{
    
   @objc optional  func getDetail(_ details:CNContact)->Void
    
   func PermissionDetail(_ success:Bool)->Void
}

class AddContactVC: BaseViewController,PhoneContact_Delegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,CNContactPickerDelegate {

    var Contact_obj = Util_Contacts()
    var isGranted : Bool = false
    var pick_contc_identifier: String = ""
    var imgPick : Bool = false
    
    @IBOutlet weak var iPhoneContact_Switch: UISwitch!
    @IBOutlet weak var ScrollVIew: UIScrollView!
    @IBOutlet weak var ProfPic_imgView: UIImageView!
    @IBOutlet weak var txt_ProfileId: UITextField!
    
    @IBOutlet weak var txt_firstName: UITextField!
    
    @IBOutlet weak var txt_lastName: UITextField!
    @IBOutlet weak var txt_zipcode: UITextField!
    @IBOutlet weak var txt_mobNum: UITextField!
    @IBOutlet weak var txt_city: UITextField!
    @IBOutlet weak var txt_address: UITextField!
    @IBOutlet weak var txt_OtherMobNum: UITextField!
    @IBOutlet weak var txt_workNumb: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_remarks: UITextField!
    
    var Sqlite = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMyView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func setMyView()->Void
    {
        ScrollVIew.contentSize = CGSize(width: ScrollVIew.frame.width,height: 667)
        ProfPic_imgView.layer.cornerRadius = ProfPic_imgView.frame.width/2
        ProfPic_imgView.layer.masksToBounds = true
        ProfPic_imgView.layer.borderWidth = 2.0
        ProfPic_imgView.layer.borderColor = UIColor.white.cgColor
        ProfPic_imgView.image = UIImage.init(named: "noImg.png")
        self.settapGesture()
       
    }
    @IBAction func click_PickContactbtn(_ sender: AnyObject)
    {
        resignMyView()
       /* Contact_obj.Delegate = self
        Contact_obj.getContacts()
        if isGranted
        {
            self.performSegueWithIdentifier("Select_contact", sender: self)
        }
        else
        {
            print("Permissin not Granted")
        }
        */
        let picker : CNContactPickerViewController = CNContactPickerViewController.init()
        picker.delegate = self;
        self.present(picker, animated: true, completion: nil)
    }
   
    @IBAction func click_SaveContactbtn(_ sender: AnyObject)
    {
        resignMyView()
        validation()
    }
    func PermissionDetail(_ success: Bool)
    {
        isGranted = success
    }
    func AddPersonDetail()->Person_Model
    {
        let person = Person_Model()
        
        person.FirstName = self.txt_firstName.text!
       // person.lastName = self.txt_lastName.text!
        person.Address = self.txt_address.text!
        person.City = self.txt_city.text!
        person.ZipCode = self.txt_zipcode.text!
        person.MobNum = self.txt_mobNum.text!
        person.OtherMobNum = self.txt_OtherMobNum.text!
        person.WorkNum = self.txt_workNumb.text!
        person.email = self.txt_email.text!
        person.remarks = self.txt_remarks.text!
        person.profile_id = self.txt_ProfileId.text!
        person.SYNC = "0"
        if imgPick
        {
            let imgpath = GetImagePath(txt_ProfileId.text!)
            if SaveImageTopath(imgpath, Image:UIImagePNGRepresentation(ProfPic_imgView.image!)!)
            {
                person.image = "true"
            }
            else
            {
                print("Fail to Save")
                person.image = "false"
            }

        }
        else
        {
            person.image = "false"
        }
        
        if iPhoneContact_Switch.isOn
        {
            person.identifier = pick_contc_identifier
        }
        else
        {
            person.identifier = ""
        }
        
        
        return person
    }
    
    func SetNilData()->Void
    {
        self.txt_firstName.text = ""
        //self.txt_lastName.text = ""
        self.txt_address.text = ""
        self.txt_city.text = ""
        self.txt_zipcode.text = ""
        self.txt_mobNum.text = ""
        self.txt_OtherMobNum.text = ""
        self.txt_workNumb.text = ""
        self.txt_email.text = ""
        self.txt_remarks.text = ""
        self.txt_ProfileId.text = ""
        self.iPhoneContact_Switch.setOn(false, animated: false)
        self.ProfPic_imgView.image = UIImage.init(named: "noImg.png")
    }
    func getDetail(_ details: CNContact)
    {
         print("%@",details)
        
        self.txt_firstName.text = details.givenName
       // self.txt_lastName.text = details.familyName
        var detail_obj : AnyObject
        var detail_value : AnyObject
        if details.postalAddresses.count > 0
        {
           detail_obj = details.postalAddresses[0]
            self.txt_address.text = detail_obj.street
          //  detail_value = detail_obj.value
          //  self.txt_address.text = detail_value.street
            self.txt_city.text = detail_obj.city
            self.txt_zipcode.text = detail_obj.postalCode
        }
        else
        {
            self.txt_address.text = ""
            self.txt_city.text = ""
            self.txt_zipcode.text = ""
        }
        if details.emailAddresses.count > 0
        {
            let obj  = details.emailAddresses[0]
            let values = obj.value as String
            self.txt_email.text = values
        }
        else
        {
            self.txt_email.text = ""
        }
        if details.phoneNumbers.count > 0
        {
           let obj = details.phoneNumbers[0]
            let values = obj.value 
            self.txt_mobNum.text = values.stringValue

           for phone_num in details.phoneNumbers
           {
            
              detail_value = phone_num.value 
            
              if  phone_num.label == CNLabelPhoneNumberMobile
              {
                self.txt_mobNum.text = detail_value.stringValue
              }
            else if phone_num.label == CNLabelPhoneNumberMain
              {
                self.txt_OtherMobNum.text = detail_value.stringValue
              }
            else if phone_num.label == CNLabelPhoneNumberiPhone
              {
                self.txt_workNumb.text = detail_value.stringValue
              }
            }
        }
        self.txt_remarks.text = details.note
        pick_contc_identifier = details.identifier
        iPhoneContact_Switch.setOn(true, animated: true)
        if (details.imageData != nil)
        {
            ProfPic_imgView.image = UIImage.init(data: details.imageData!)
            imgPick = true
            
        }
    
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Select_contact"
        {
            let vc2 = segue.destination as! PhoneContactListVC
          vc2.delegate = self
        }
    }
   
    func AddnewContact_Phone()
    {
        var contact =  CNMutableContact()
         contact =  setvalueForiPhone(contact)
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        try! store.execute(saveRequest)

    }
    
    func Save_to_iPhone(_ identifier:String)
    {
        let contactArray =  Contact_obj.retrieveContactsWithIdentifier(identifier)
        if contactArray.count > 0
        {
            let contact = setvalueForiPhone(contactArray [0].mutableCopy() as! CNMutableContact)
            
            
            let identifier = contact.identifier
            print("\(identifier)")
            
            let store = CNContactStore()
            let saveRequest = CNSaveRequest()
            saveRequest.update(contact)
            try! store.execute(saveRequest)
        }
 
    }
    
    func setvalueForiPhone(_ contact:CNMutableContact)->CNMutableContact
    {
        contact.givenName = self.txt_firstName.text!;
       // contact.familyName = self.txt_lastName.text!;
        
        let MobileNo = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: self.txt_mobNum.text!))
        let OtherMobNum = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: self.txt_OtherMobNum.text!))
        let WorkNum = CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: self.txt_workNumb.text!))
        
        contact.phoneNumbers = [MobileNo,OtherMobNum,WorkNum]
        
        
        let contactAddress = CNMutablePostalAddress()
        contactAddress.street = self.txt_address.text!
        contactAddress.city = self.txt_city.text!
        contactAddress.postalCode = self.txt_zipcode.text!
        
        contact.postalAddresses = [CNLabeledValue(label: CNLabelHome, value: contactAddress)]
        
        let emailAddress = CNLabeledValue(label: CNLabelHome, value:self.txt_email.text! as NSString)
        contact.emailAddresses = [emailAddress]
        
        contact.note = self.txt_remarks.text!
        if imgPick
        {
          contact.imageData = UIImagePNGRepresentation((ProfPic_imgView?.image!)!)
        }
      
        return contact
    }

    func settapGesture()
    {
        let tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(AddContactVC.ImageTap(_:)))
        self.ProfPic_imgView.addGestureRecognizer(tapGesture)
        self.ProfPic_imgView.isUserInteractionEnabled = true
        
    }
    func ImageTap(_ recognizer:UITapGestureRecognizer)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let CancelBtn = UIAlertAction.init(title: "Cancel", style:.destructive)
        { (action) -> Void in
            sheet.dismiss(animated: true, completion: nil)
        }
        
        let GallaryBtn = UIAlertAction.init(title: "Choose Photo", style: .default)
        { (ACTION) -> Void in
            
            picker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            self.present(picker, animated: true, completion: nil)
        }
        
        let CameraBtn = UIAlertAction.init(title: "Take Photo", style: .default)
        { (action) -> Void in
            
         if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
         {
             picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
         }
         else
         {
           let alert = UIAlertController.init(title: "Error", message: "Camera not found!", preferredStyle: .alert)
           let alertCancel =  UIAlertAction.init(title: "OK", style: .cancel, handler: { (ACTION) -> Void in
            
           })
            alert.addAction(alertCancel);
            self.resignMyView()
            self.present(alert, animated: true, completion: nil)
         }
        }
        sheet.addAction(GallaryBtn)
        sheet.addAction(CameraBtn)
        sheet.addAction(CancelBtn)
        
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        ProfPic_imgView.image = image;
        imgPick = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func validation()
    {
        if validateString(txt_ProfileId.text!)
        {
            if Sqlite.AvailbleProfile(txt_ProfileId.text!)
            {
                if validateString(txt_firstName.text!)
                {
                    insertData()
                }                
                else if validateString(txt_mobNum.text!)
                {
                    insertData()
                }
                else if validateString(txt_OtherMobNum.text!)
                {
                    insertData()
                }
                else if validateString(txt_workNumb.text!)
                {
                    insertData()
                }
                else if validateString(txt_address.text!)
                {
                    insertData()
                }
                else if validateString(txt_city.text!)
                {
                    insertData()
                }
                else if validateString(txt_zipcode.text!)
                {
                    insertData()
                }
                else if validateString(txt_email.text!)
                {
                    insertData()
                }
                else if validateString(txt_remarks.text!)
                {
                    insertData()
                }
                else
                {
                    ShowErrorlabel("All detail can not be blank,enter atleast any one detail")
                }

            }
            else
            {
                self.ShowErrorlabel("Profile ID already used,Enter unique profile id")
            }
        }
        else
        {
                 self.ShowErrorlabel("Enter valid Profile ID")
        }
    }
    func insertData()
    {
        let person = self.AddPersonDetail()
        
        let PersonArray = NSMutableArray()
        PersonArray.add(person)
        
        if Sqlite.Insert(PersonArray)
        {
            if iPhoneContact_Switch.isOn
            {
                if pick_contc_identifier != ""
                {
                    Save_to_iPhone(pick_contc_identifier)
                }
                else
                {
                    AddnewContact_Phone()
                }
                self.SetNilData()
                self.ShowErrorlabel("Contact saved successfully")
                UplodContacToSearver()
                
            }
            else
            {
                self.SetNilData()
                self.ShowErrorlabel("Contact saved successfully")
                UplodContacToSearver()
            }
            
        }
        else
        {
            self.ShowErrorlabel("Unable to save contact,Please try again later")
        }
    }
  
    func UplodContacToSearver()
    {
        let uplodBG = UploadContactBG()
        uplodBG.GetUploadContactList()
    }
 
    func resignMyView()
    {
        txt_address.resignFirstResponder()
        txt_city.resignFirstResponder()
        txt_email.resignFirstResponder()
        txt_firstName.resignFirstResponder()
        txt_mobNum.resignFirstResponder()
        txt_OtherMobNum.resignFirstResponder()
        txt_ProfileId.resignFirstResponder()
        txt_remarks.resignFirstResponder()
        txt_workNumb.resignFirstResponder()
        txt_zipcode.resignFirstResponder()
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        resignMyView()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
       if textField == txt_ProfileId
       {
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
       }
        else if textField == txt_firstName
       {
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 10), animated: true)
        }
        else if textField == txt_mobNum
       {
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 30), animated: true)
        }
        else if textField == txt_OtherMobNum
       {
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        }
        else if textField == txt_workNumb
       {
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
        }
        else if textField == txt_address
       {
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
        else if textField == txt_city
       {
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
        else if textField == txt_zipcode
       {
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 220), animated: true)
        }
        else if textField == txt_email
       {
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 260), animated: true)
        }
        else if textField == txt_remarks
       {
        self.ScrollVIew.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        }
        return true
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact)
    {
        self.getDetail(contact)
        picker.dismiss(animated: true, completion: nil)
        
        print("selected contact is \(contact.givenName)")
    }
    
}
