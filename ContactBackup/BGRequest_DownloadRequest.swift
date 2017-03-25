//
//  BGRequest_DownloadRequest.swift
//  ContactBackup
//
//

import UIKit

class BGRequest_DownloadRequest: BaseBackGroundRequest
{
    override func sendRequest(_ objModel: BaseModel?, objViewController: BGBaseHandler)
    {
        self.url = URLGenerator.GetMethodForContacts("GetContact", Parameter: (objModel?.parameter)!)
        self.obj_reqModel = objModel
        self.requestDelegate = objViewController
        self.obj_baseParser = Parser_DownloadBG()
        self.HTTPMethod = "GET"
        sendRequestToServer(NSMutableDictionary())
//GetContact.php?userid=9327005120
    }
}
