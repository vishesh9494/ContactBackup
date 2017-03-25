//
//  DownloadContactBG.swift
//  ContactBackup
//
//

import UIKit
import Contacts

class DownloadContactBG: BGBaseHandler
{
    var Contact_obj = Util_Contacts()
    
    override func DownloadContacts()
    {
        let req_bg = BGRequest_DownloadRequest()
        let model = BaseModel()
        let dic = NSMutableDictionary()//userid=9327005120
        dic.setValue("userid", forKey: "key")
        dic.setValue(UserDefaults.standard.value(forKey: "userid"), forKey: "value")
        model.parameter = NSMutableArray()
        model.parameter?.add(dic)
        req_bg.sendRequest(model, objViewController: self)

    }
    
    override func onReply(_ res_data: Data, objParser: BasebackGroundParser, req_model: BaseModel)
    {
        if objParser.isKind(of: Parser_DownloadBG.self)
        {
            let res_obj = objParser.doParsing_Downlod(res_data)
            let ob = res_obj[0] as! BaseModel
            if ob.resposeStatus == 0
            {
                if ob.errorCode == "-1"
                {
                    
                }
                else
                {
                   if sqlite.Insert(res_obj)
                   {
                   // for var i = 0 ;i < res_obj.count ; i += 1
                    for var i in 0..<res_obj.count
                    {
                        let req_bg = BGRequest_DownloadRequest()
                        let obj = res_obj[i] as! Person_Model
                        let imgName = obj.profile_id
                         Save_to_iPhone(obj)
                         if obj.image == "true"
                        {
                            req_bg.downloadImag(imgName)
                        }
                    }
                   }
                }
            }
            else
            {
                
            }
        }
    }
    override func connectionError(_ req_model: BaseModel)
    {
       
    }
    
   
    func Save_to_iPhone(_ obj : Person_Model)
    {
        let contactArray =  Contact_obj.retrieveContactsWithIdentifier(obj.identifier)
        if contactArray.count > 0
        {
            let contact = setvalueForiPhone(contactArray [0].mutableCopy() as! CNMutableContact, object:obj)
            
            
            let identifier = contact.identifier
            print("\(identifier)")
            
            let store = CNContactStore()
            let saveRequest = CNSaveRequest()
            saveRequest.update(contact)
            try! store.execute(saveRequest)
        }
        else
        {
            var contact =  CNMutableContact()
            contact =  setvalueForiPhone(contact,object: obj)
            
            let store = CNContactStore()
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier:nil)
            try! store.execute(saveRequest)
        }

    }
    
    func setvalueForiPhone(_ contact:CNMutableContact,object : Person_Model)->CNMutableContact
    {
        
        contact.givenName = object.FirstName;
        // contact.familyName = self.txt_lastName.text!;
        
        let MobileNo = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: object.MobNum))
        let OtherMobNum = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: object.OtherMobNum))
        let WorkNum = CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: object.WorkNum))
        
        contact.phoneNumbers = [MobileNo,OtherMobNum,WorkNum]
        
        
        let contactAddress = CNMutablePostalAddress()
        contactAddress.street = object.Address
        contactAddress.city = object.City
        contactAddress.postalCode = object.ZipCode
        
        contact.postalAddresses = [CNLabeledValue(label: CNLabelHome, value: contactAddress)]
        
        let emailAddress = CNLabeledValue(label: CNLabelHome, value:(object.email ) as NSString)
        contact.emailAddresses = [emailAddress]
        
        contact.note = object.remarks
        
        return contact
    }
}
