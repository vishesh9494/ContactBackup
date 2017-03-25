//
//  Req_notification.swift
//  ContactBackup
//
//

import UIKit

class Req_notification: BaseRequest
{
    override func sendRequest(_ objModel: BaseModel?, objViewController: BaseViewController)
    {
        self.url = URLGenerator.GetMethodForContacts("GetProfileNotifications", Parameter: (objModel?.parameter)!)
        self.obj_reqModel = objModel
        self.requestDelegate = objViewController
        self.obj_baseViewController = objViewController
        self.obj_baseParser = Parser_notification()
        self.HTTPMethod = "GET"
        sendRequestToServer(NSDictionary())
    }
 
}
//GetProfileNotifications.php?userid=9327005120
