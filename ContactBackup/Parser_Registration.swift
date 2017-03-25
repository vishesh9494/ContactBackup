//
//  Parser_Registration.swift
//  ContactBackup
//
//

import UIKit

class Parser_Registration: BaseParser
{
    
  /*  override func getParser(data: NSData) -> NSMutableArray
    {
        let valArray = NSMutableArray()
        do
        {
            let res_array : NSArray = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSArray
            
            let dic = res_array[0]
            let obj = BaseModel()
            obj.errorCode = dic.valueForKey("") as? String
            valArray.addObject(obj)
        }catch
        {
           // self.requestDelegate?.getDataNil()
            print("Exception is \(error)")
        }
        

        return valArray
    }*/
    
    override func performData(_ res_data: Data) -> BaseModel
    {
        let obj = BaseModel()
        do
        {
            let res_array : NSArray = try JSONSerialization.jsonObject(with: res_data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            let dic = res_array[0]
            obj.errorCode = (dic as AnyObject).value(forKey: "error") as? String
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
