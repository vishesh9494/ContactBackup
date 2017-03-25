//
//  Req_Reset.swift
//  ContactBackup
//
//

import UIKit

class Req_Reset: BaseRequest
{
    override func sendRequest(_ objModel: BaseModel?, objViewController: BaseViewController)
    {
        self.url = URLGenerator.GETMethodForReset("verifyReset", Parameter: (objModel?.parameter)!)
        self.obj_reqModel = objModel
        self.requestDelegate = objViewController
        self.obj_baseViewController = objViewController
        self.obj_baseParser = Parser_Reset()
        self.HTTPMethod = "GET"
        sendRequestToServer(NSDictionary())
    }
}
