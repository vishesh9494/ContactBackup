//
//  Req_SaveRequest.swift
//  ContactFetchSwift
//
//

import UIKit

class Req_SaveRequest: BaseRequest
{
    override func sendRequest(_ objModel: BaseModel?, objViewController: BaseViewController)
    {        
        self.obj_reqModel = objModel
        self.requestDelegate = objViewController
        self.obj_baseViewController = objViewController
        self.obj_baseParser = Parser_SaveRequest()
        self.HTTPMethod = "POST"
    
    }
}
