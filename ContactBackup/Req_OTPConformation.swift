//
//  Req_OTPConformation.swift
//  ContactBackup
//
//

import UIKit

class Req_OTPConformation: BaseRequest
{
    override func sendRequest(_ objModel: BaseModel?, objViewController: BaseViewController)
    {
        self.url = URLGenerator.GetMethodForRegistration("VerifyUser", Parameter: (objModel?.parameter)!)
        self.obj_reqModel = objModel
        self.requestDelegate = objViewController
        self.obj_baseViewController = objViewController
        self.obj_baseParser = Parser_OTPConformastion()
        self.HTTPMethod = "GET"
        sendRequestToServer(NSDictionary())
    }
}
