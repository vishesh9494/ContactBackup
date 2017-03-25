//
//  ViewContactVC.swift
//  ContactBackup
//
//

import UIKit
import Contacts
import MessageUI

class ViewContactVC: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate {

    var obj = Person_Model()
    var sqlite = DatabaseManager()
    var Contact_obj = Util_Contacts()
    var isFrom = Selection.rowSelection
    
    @IBOutlet weak var emailBtn: UIButton!
    var imgPick: Bool = false
    
    @IBOutlet weak var mobCallBtn: UIButton!
    @IBOutlet weak var alterCallBtn: UIButton!
    @IBOutlet weak var officeCallBtn: UIButton!
    @IBOutlet weak var Profpic_imgView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txt_profileId: UITextField!
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    
    @IBOutlet weak var txt_address: UITextField!
    @IBOutlet weak var txt_city: UITextField!
    @IBOutlet weak var txt_zipcode: UITextField!
    @IBOutlet weak var txt_mobNum: UITextField!
    @IBOutlet weak var txt_OtherMobNum: UITextField!
    @IBOutlet weak var txt_workNum: UITextField!
    
    @IBOutlet weak var txt_remarks: UITextField!
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var btn_saveToiPhone: UIButton!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMyView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Click_Backbtn(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func Click_SaveToiPhonebtn(_ sender: AnyObject)
    {
      
        
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
        //contact.familyName = self.txt_lastName.text!;
        
        let MobileNo = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: self.txt_mobNum.text!))
        let OtherMobNum = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: self.txt_OtherMobNum.text!))
        let WorkNum = CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: self.txt_workNum.text!))
        
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
            contact.imageData = UIImagePNGRepresentation(Profpic_imgView.image!)
        }

        return contact
    }
    
   func setMyView()->Void
   {
    self.txt_firstName.text = obj.FirstName
   // self.txt_lastName.text = obj.lastName
    self.txt_address.text = obj.Address
    self.txt_city.text = obj.City
    self.txt_zipcode.text = obj.ZipCode
    self.txt_mobNum.text = obj.MobNum
    self.txt_OtherMobNum.text = obj.OtherMobNum
    self.txt_workNum.text = obj.WorkNum
    self.txt_email.text = obj.email
    self.txt_remarks.text = obj.remarks
    self.txt_profileId.text = obj.profile_id
    self.txt_profileId.isEnabled = false
    Profpic_imgView.layer.cornerRadius = Profpic_imgView.frame.width/2
    Profpic_imgView.layer.masksToBounds = true
    Profpic_imgView.layer.borderWidth = 2.0
    Profpic_imgView.layer.borderColor = UIColor.white.cgColor    
    if obj.image == "true"
    {
      Profpic_imgView.image = UIImage.init(contentsOfFile: GetImagePath(obj.profile_id))
       //imgPick = true
    }
    else
    {
        Profpic_imgView.image = UIImage.init(named: "noImg.png")
       // imgPick = false
    }
    switch isFrom
    {
    case .logPress :
        self.setEditable(true)
        self.settapGesture()
        break
        
    case .rowSelection:
        self.setEditable(false)
        break
    }
    
    
    
    self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: 667)
    
   }
    
    func setEditable(_ edit:Bool)
    {
        self.txt_firstName.isEnabled = edit
        //self.txt_lastName.enabled = edit
        self.txt_address.isEnabled = edit
        self.txt_city.isEnabled = edit
        self.txt_zipcode.isEnabled = edit
        self.txt_mobNum.isEnabled = edit
        self.txt_OtherMobNum.isEnabled = edit
        self.txt_workNum.isEnabled = edit
        self.txt_email.isEnabled = edit
        self.txt_remarks.isEnabled = edit
        self.btn_edit.isHidden = !edit
        
            ManageCallBtns(edit)
        
        
        self.txt_profileId.isEnabled = false
    }
    func ManageCallBtns(_ edit : Bool)
    {
        if edit
        {
            self.mobCallBtn.isHidden = edit
            self.alterCallBtn.isHidden = edit
            self.officeCallBtn.isHidden = edit
            self.emailBtn.isHidden = edit
        }
        else
        {
            if self.txt_mobNum.text != ""
            {
                self.mobCallBtn.isHidden = edit
            }
            else
            {
                self.mobCallBtn.isHidden = !edit
            }
            if  self.txt_OtherMobNum.text != ""
            {
                self.alterCallBtn.isHidden = edit
            }
            else
            {
                self.alterCallBtn.isHidden = !edit
            }
            if  self.txt_workNum.text != ""
            {
                self.officeCallBtn.isHidden = edit
            }
            else
            {
                self.officeCallBtn.isHidden = !edit
            }
            if self.txt_email.text != ""
            {
                self.emailBtn.isHidden = edit
            }
            else
            {
                self.emailBtn.isHidden = !edit
            }
            

        }
    }
    @IBAction func Click_Cancelbtn(_ sender: AnyObject)
    {
       self.dismiss(animated: true, completion: nil)
    }

    @IBAction func Click_Savebtn(_ sender: AnyObject)
    {
       validation()
       resignMyView()
    }
    
    func UpdateData()
    {
       
       let model = self.setData()
      if sqlite.UpdateContact(model)
      {
         if obj.identifier != ""
         {
            Save_to_iPhone(obj.identifier)
            UplodContacToSearver()
         }
        else
         {
            UplodContacToSearver()
          }
        self.ShowErrorlabel("Contact updated successfully.")
        self.dismiss(animated: true, completion: nil)
      }
        else
        {
           
           self.ShowErrorlabel("Unable to update contact,Please try again.")
        }
        
    }
    func UplodContacToSearver()
    {
        let uplodBG = UploadContactBG()
        uplodBG.GetUploadContactList()
    }
    func setData()->NSMutableArray
    {
        let model : NSMutableArray = []
        
        let person = Person_Model()
        
        person.FirstName = self.txt_firstName.text!
       // person.lastName = self.txt_lastName.text!
        person.Address = self.txt_address.text!
        person.City = self.txt_city.text!
        person.ZipCode = self.txt_zipcode.text!
        person.MobNum = self.txt_mobNum.text!
        person.OtherMobNum = self.txt_OtherMobNum.text!
        person.WorkNum = self.txt_workNum.text!
        person.email = self.txt_email.text!
        person.remarks = self.txt_remarks.text!
        person.contact_id = obj.contact_id
        person.SYNC = "0"
        if imgPick
        {
               let imgPath = self.GetImagePath(txt_profileId.text!)
               
                if SaveImageTopath(imgPath, Image: UIImagePNGRepresentation(self.Profpic_imgView.image!)!)
                {
                   person.image = "true"
                }
            
        }
        else
        {
           person.image = obj.image
        }
        
        model.add(person)
        
        return model
    }
    func validation()
    {
        if validateString(txt_profileId.text!)
        {
            if validateString(txt_firstName.text!)
            {
               UpdateData()
            }
            else if validateString(txt_mobNum.text!)
            {
                UpdateData()
            }
            else if validateString(txt_OtherMobNum.text!)
            {
               UpdateData()
            }
            else if validateString(txt_workNum.text!)
            {
                UpdateData()
            }
            else if validateString(txt_address.text!)
            {
                UpdateData()
            }
            else if validateString(txt_city.text!)
            {
                UpdateData()
            }
            else if validateString(txt_zipcode.text!)
            {
                UpdateData()
            }
            else if validateString(txt_email.text!)
            {
                UpdateData()
            }
            else if validateString(txt_remarks.text!)
            {
                UpdateData()
            }
            else
            {
                ShowErrorlabel("All detail can not be blank,enter atleast any one detail")
            }
        }
        else
        {
            self.ShowErrorlabel("Enter valid Profile ID")
        }
    }

    func settapGesture()
    {
        let tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(ViewContactVC.ImageTap(_:)))
        self.Profpic_imgView.addGestureRecognizer(tapGesture)
        self.Profpic_imgView.isUserInteractionEnabled = true
        
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
        Profpic_imgView.image = image;
        imgPick = true
        picker.dismiss(animated: true, completion: nil)
    }

  
    @IBAction func Click_emailBtn(_ sender: AnyObject)
    {
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setToRecipients([self.txt_email.text!])
        present(picker, animated: true, completion: nil)
    
    }
    @IBAction func Click_officeCallBtn(_ sender: AnyObject)
    {
        var phoneNumber = "tel://"
       phoneNumber += removeSpecialCharsFromString(self.txt_workNum.text!)
        UIApplication.shared.openURL(URL.init(string: phoneNumber)!)
    }
    @IBAction func Click_AlterCallBtn(_ sender: AnyObject)
    {
        var phoneNumber = "tel://"
       phoneNumber += removeSpecialCharsFromString(self.txt_OtherMobNum.text!)
        UIApplication.shared.openURL(URL.init(string: phoneNumber)!)
    }

    @IBAction func click_MobCallBtn(_ sender: AnyObject)
    {
        var phoneNumber = "tel://"
        phoneNumber += removeSpecialCharsFromString(self.txt_mobNum.text!)
        UIApplication.shared.openURL(URL.init(string: phoneNumber)!)
    }
    
    func removeSpecialCharsFromString(_ text: String) -> String
    {
        let okayChars : Set<Character> =
        Set("1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    func resignMyView()
    {
            txt_address.resignFirstResponder()
            txt_city.resignFirstResponder()
            txt_email.resignFirstResponder()
            txt_firstName.resignFirstResponder()
            txt_mobNum.resignFirstResponder()
            txt_OtherMobNum.resignFirstResponder()
            txt_profileId.resignFirstResponder()
            txt_remarks.resignFirstResponder()
            txt_workNum.resignFirstResponder()
            txt_zipcode.resignFirstResponder()
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        resignMyView()
        return true
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txt_profileId
        {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else if textField == txt_firstName
        {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 10), animated: true)
        }
        else if textField == txt_mobNum
        {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 30), animated: true)
        }
        else if textField == txt_OtherMobNum
        {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        }
        else if textField == txt_workNum
        {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
        }
        else if textField == txt_address
        {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
        else if textField == txt_city
        {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
        else if textField == txt_zipcode
        {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 220), animated: true)
        }
        else if textField == txt_email
        {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 260), animated: true)
        }
        else if textField == txt_remarks
        {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        }
        return true
    }

}
