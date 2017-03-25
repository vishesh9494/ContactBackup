//
//  UploadContactBG.swift
//  ContactBackup
//
//

import UIKit

class UploadContactBG: BGBaseHandler
{
    override func GetUploadContactList()
    {
        let contacts = sqlite.GetContactTobeUpload()
        for i in 0  ..< contacts.count 
        {
            let req_bg = BGRequest_UploadRequest()
            let contactModel = contacts[i] as! Person_Model
            let imgName = contactModel.image
            req_bg.sendRequest(contactModel, objViewController: self)
            if imgName == "true"
            {
                let img = UIImage.init(named:GetImagePath(contactModel.profile_id))! as UIImage
                req_bg.uploadImageForPHP(img, name:contactModel.profile_id)
            }
        }
    }
    
    override func onReply(_ res_data: Data, objParser: BasebackGroundParser, req_model: BaseModel)
    {
        if objParser.isKind(of: Parser_UploadBG.self)
        {
            let res_obj = objParser.doParsing(res_data)
            if res_obj.resposeStatus == 0
            {
                if res_obj.errorCode == "-1"
                {
                    sqlite.UpdateSync(req_model)
                }
                else
                {
                    
                }
            }
            else
            {
                
            }
        }
    }
    override func connectionError(_ req_model: BaseModel)
    {
         }
    
}
