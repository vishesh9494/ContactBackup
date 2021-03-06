//
//  Parser_notification.swift
//  ContactBackup
//
//

import UIKit

class Parser_notification: BaseParser
{
    override func performData(_ res_data: Data) -> BaseModel
    {
        let obj = BaseModel()
        do
        {
            let res_array : NSArray = try JSONSerialization.jsonObject(with: res_data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            let dic = res_array[0]
            obj.errorCode = (dic as AnyObject).value(forKey: "error") as? String
            if obj.errorCode == ""
            {
               obj.msg = NSMutableArray()
                for i in 0  ..< res_array.count 
                {
                    let dic_msg = res_array[i]
                    let obj_model = Model_notiification()
                    obj_model.Message = (dic_msg as AnyObject).value(forKey: "msg") as? String
                    obj_model.userId = (dic_msg as AnyObject).value(forKey: "userid") as? String
                    obj.msg?.add(obj_model)
                }
            }
            obj.resposeStatus = 0
            
        }catch
        {
            // self.requestDelegate?.getDataNil()
            obj.resposeStatus = 1
            print("Exception is \(error)")
        }
        return obj
    }
}
//[{"msg":"notification rishk is studying","userid":"9327005120","error":""}]
