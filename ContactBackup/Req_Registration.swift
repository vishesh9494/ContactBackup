//
//  Req_Registration.swift
//  ContactBackup
//
//

import UIKit

class Req_Registration: BaseRequest
{
    override func sendRequest(_ objModel: BaseModel?, objViewController: BaseViewController)
    {
        self.url = URLGenerator.GetMethodForRegistration("RegisterUser", Parameter: (objModel?.parameter)!)
        self.obj_reqModel = objModel
        self.requestDelegate = objViewController
        self.obj_baseViewController = objViewController
        self.obj_baseParser = Parser_Registration()
        self.HTTPMethod = "GET"
        sendRequestToServer(NSDictionary())
    }
}
