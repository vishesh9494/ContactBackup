//
//  Parser_OTPConformastion.swift
//  ContactBackup
//
//

import UIKit

class Parser_OTPConformastion: BaseParser
{
    override func performData(_ res_data: Data) -> BaseModel
    {
        let obj = BaseModel()
        do
        {
            let res_array : NSArray = try JSONSerialization.jsonObject(with: res_data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            let dic = res_array[0]
            obj.errorCode = (dic as AnyObject).value(forKey: "error") as? String
            obj.errorCode = "-1"
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
