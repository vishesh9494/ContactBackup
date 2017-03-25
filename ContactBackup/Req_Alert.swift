//
//  Req_Alert.swift
//  ContactBackup
//
//

import UIKit

class Req_Alert: BaseRequest
{
    override func sendRequest(_ objModel: BaseModel?, objViewController: BaseViewController)
    {
        self.url = URLGenerator.GetMethodForContacts("GetProfileAlerts", Parameter: (objModel?.parameter)!)
        self.obj_reqModel = objModel
        self.requestDelegate = objViewController
        self.obj_baseViewController = objViewController
        self.obj_baseParser = parser_Alert()
        self.HTTPMethod = "GET"
        sendRequestToServer(NSDictionary())
    }
}
//GetProfileAlerts.php?userid=9327005120
