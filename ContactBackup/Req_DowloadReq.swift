//
//  Req_DowloadReq.swift
//  ContactBackup
//
//

import UIKit

class Req_DowloadReq: BaseRequest
{
    override func sendRequest(_ objModel: BaseModel?, objViewController: BaseViewController)
    {
        self.url = URLGenerator.GetMethodForContacts("GetDownload", Parameter: (objModel?.parameter)!)
        self.obj_reqModel = objModel
        self.requestDelegate = objViewController
        self.obj_baseViewController = objViewController
        self.obj_baseParser = Parser_DonloadReq()
        self.HTTPMethod = "GET"
        sendRequestToServer(NSDictionary())
    }
}
