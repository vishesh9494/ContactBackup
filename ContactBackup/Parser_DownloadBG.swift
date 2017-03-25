//
//  Parser_DownloadBG.swift
//  ContactBackup
//
//

import UIKit

class Parser_DownloadBG: BasebackGroundParser
{
    
    
    override func doParsing_Downlod(_ res_data: Data) -> NSMutableArray
    {
        
        let objArray = NSMutableArray()
    
        do
        {
            let res_array : NSArray = try JSONSerialization.jsonObject(with: res_data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
            if res_array.count > 0
           {
              if (res_array[0] as AnyObject).value(forKey: "error")as! String != ""
              {
                 let obj  = Person_Model()
                 obj.errorCode = "-1"
                 obj.resposeStatus = 0
                objArray.add(obj)
              }
              else
              {
                for i in 0  ..< res_array.count 
                {
                   let  obj = Person_Model()
                    obj.resposeStatus = 0
                    let res_obj = res_array[i] as! NSDictionary
                    obj.FirstName = res_obj.value(forKey: "cname") as! String
                    obj.profile_id = res_obj.value(forKey: "profileid") as! String
                    obj.Address = res_obj.value(forKey: "caddress") as! String
                    obj.City = res_obj.value(forKey: "ccity")   as! String
                    obj.ZipCode = res_obj.value(forKey: "czip")   as! String
                    obj.MobNum = res_obj.value(forKey: "cphone")  as! String
                    obj.OtherMobNum = res_obj.value(forKey: "cotherphone")  as! String
                    obj.email = res_obj.value(forKey: "cemail")  as! String
                    obj.remarks = res_obj.value(forKey: "cnotes")   as! String
                    obj.image =  res_obj.value(forKey: "cphoto") as! String
               //     obj.identifier = res_obj.value(forKey: "phonecontactidentifier") as! String
                    let str = res_obj.value(forKey: "clabphone")
                    if  !(str is  NSNull)
                    {
                          obj.WorkNum = res_obj.value(forKey: "clabphone")  as! String
                    }
                   
                    obj.errorCode = "0"
                    objArray.add(obj)
                   
                }
              }
           }
           
            
        }catch
        {
            // self.requestDelegate?.getDataNil()
            let  obj = Person_Model()
             obj.resposeStatus = 1
             objArray.add(obj)
            print("Exception is \(error)")
        }
        return objArray
    }
}

/*pkid: "339",
error: "",
cname: "Anna",
profileid: "Anna",
caddress: "1001 Leavenworth Street",
ccity: "Sausalito",
czip: "94965notes=",
cphone: "555-522-8243",
cotherphone: "",
cemail: "anna-haro@mac.com",
cgroup: null,
cnotes: "",
phonecontactidentifier: "8DE9E5B5-FEAF-4D4D-84D6-1CC4C3C2FA4D",
clabphone: "",
cphoto: "false"*/
