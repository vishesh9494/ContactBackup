//
//  Util_Contacts.swift
//  ContactBackup
//
//

import UIKit
import Contacts


class Util_Contacts: NSObject
{
    var objects = [CNContact]()
    let store = CNContactStore()
    var Delegate : PhoneContact_Delegate?
     let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactNoteKey,CNContactPostalAddressesKey,CNContactEmailAddressesKey,CNContactImageDataKey]
    
    func getContacts()
    {
       
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined
        {
            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
                if authorized
                {
                   self.Delegate?.PermissionDetail(true)
                }
            } as! (Bool, Error?) -> Void)
            
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized
        {
             self.Delegate?.PermissionDetail(true)
        }
    }
    
    func retrieveContactsWithStore()-> [CNContact]
    {
        var contact:[CNContact] = []
        do
        {
            
            let containerId = CNContactStore().defaultContainerIdentifier()
            let predicate: NSPredicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
            let contacts = try CNContactStore().unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
            
              contact = contacts
           
            
        }
        catch
        {
            print(error)
        }
        return contact
    }
    func retrieveContactsWithIdentifier(_ identifier:String)->[CNContact]
    {
        var contact:[CNContact] = []
        do
        {
            let containerId = identifier
            let predicate: NSPredicate = CNContact.predicateForContacts(withIdentifiers: [containerId])
            let contacts = try CNContactStore().unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
            
            contact = contacts
        }
        catch
        {
            print(error)
        }
        return contact
    }

}
