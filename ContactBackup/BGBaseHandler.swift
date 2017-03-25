//
//  BGBaseHandler.swift
//  ContactFetchSwift
//
//
//  
//

import UIKit

class BGBaseHandler: NSObject,BGOnReplyDelegate
{
    // MARK : Onreply Delegate
    var  sqlite = DatabaseManager()
    var notification : NotificationCenter?
    func onReply(_ res_data: Data, objParser: BasebackGroundParser, req_model: BaseModel)
    {
     
    }
    
    func connectionError(_ req_model: BaseModel)
    {
       
    }
    
    func getNilData()
    {
       
    }
    
    func GetUploadContactList()
    {       
            
    }
    func DownloadContacts()
    {
        
    }
    func GetImagePath(_ imgName:String)->String
    {
        let documents =  try!FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let fileUrl = documents.appendingPathComponent("\(imgName)")
        
        return fileUrl.path
    }
}
