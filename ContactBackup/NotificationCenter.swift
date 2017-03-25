//
//  NotificationCenter.swift
//  ContactBackup
//
//

import UIKit

class NotificationCenter: NSObject
{
    
    var  reachability  : Reachability?
    
     func setupNotification()
    {
        
        Foundation.NotificationCenter.default.addObserver(self, selector: #selector(NotificationCenter.reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
       
        
        self.reachability = Reachability.forInternetConnection()
        
        self.reachability?.startNotifier()
    }
    
    func reachabilityChanged (_ notification:Notification) -> Void
    {
        let reach : Reachability = notification.object as! Reachability
        
        if (reach == self.reachability)
        {
            if(reach.isReachable())
            {
                if (UserDefaults.standard.object(forKey: "userid") != nil)
                {
                    let isLogin : NSString = UserDefaults.standard.object(forKey: "userid") as! NSString
                    
                    
                    if isLogin.length > 0
                    {
                        UplodContacToSearver()
                        DownlodContactFromServer()
                    }
                }
                
            }
            else
            {
                
            }
        }
    }
    
    func DownlodContactFromServer()
    {
        let donldBG = DownloadContactBG()
        donldBG.DownloadContacts()
    }
    
    func UplodContacToSearver()
    {
        let uplodBG = UploadContactBG()
        uplodBG.GetUploadContactList()
    }
}
