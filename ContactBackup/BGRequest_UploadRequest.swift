//
//  BGRequest_UploadRequest.swift
//  ContactFetchSwift
//
//

import UIKit

class BGRequest_UploadRequest: BaseBackGroundRequest
{
    /*   self.url = URLGenerator.GetMethodForRegistration("RegisterUser", Parameter: (objModel?.parameter)!)
    self.obj_reqModel = objModel
    self.requestDelegate = objViewController
    self.obj_baseViewController = objViewController
    self.obj_baseParser = Parser_Registration()
    self.HTTPMethod = "GET"
    sendRequestToServer(NSDictionary())
    */
    override func sendRequest(_ objModel: BaseModel?, objViewController: BGBaseHandler) {
        self.url = URLGenerator.GetMethodForUplodContact()
        self.obj_reqModel = objModel
        self.requestDelegate = objViewController
        self.obj_baseParser = Parser_UploadBG()
        self.HTTPMethod = "POST"
        let obj = objModel as! Person_Model
         let dataObj = GetData(obj)
        sendRequestToServerwithFormData(dataObj)
        
//        let req_dic = NSMutableDictionary()
//        req_dic.setValue(obj.FirstName, forKey:"name")
//        req_dic.setValue(obj.profile_id, forKey: "profileid")
//        req_dic.setValue(obj.MobNum, forKey: "contact")
//        req_dic.setValue(obj.OtherMobNum, forKey: "otherphone")
//        req_dic.setValue(obj.email, forKey: "email")
//        req_dic.setValue(obj.Address, forKey: "address")
//        req_dic.setValue(obj.City, forKey: "city")
//        req_dic.setValue(obj.ZipCode, forKey: "pincode")
//        req_dic.setValue(obj.remarks, forKey: "notes")
//        req_dic.setValue("0", forKey: "catid")
//        req_dic.setValue("a", forKey: "deleteuser")
//        req_dic.setValue(obj.WorkNum, forKey: "labphone")
//        req_dic.setValue(obj.identifier, forKey: "phonecontactidentifier")
//        req_dic.setValue(NSUserDefaults.standardUserDefaults().valueForKey("userid"), forKey: "userid")
//        req_dic.setValue(obj.image, forKey: "userimg")
        
        
        
        
    }
    
}

func GetData(_ obj:Person_Model) -> NSMutableData
{
    let userid = UserDefaults.standard.value(forKey: "userid")
    var postData = NSMutableData(data: "userid=\(userid)".data(using: String.Encoding.utf8)!)
    postData.append("&deleteuser=a".data(using: String.Encoding.utf8)!)
    postData.append("&profileid=\(obj.profile_id)".data(using: String.Encoding.utf8)!)
    postData.append("&name=\(obj.FirstName)".data(using: String.Encoding.utf8)!)
    postData.append("&contact=\(obj.MobNum)".data(using: String.Encoding.utf8)!)
    postData.append("&otherphone=\(obj.OtherMobNum)".data(using: String.Encoding.utf8)!)
    postData.append("&email=\(obj.email)".data(using: String.Encoding.utf8)!)
    postData.append("&address=\(obj.Address)".data(using: String.Encoding.utf8)!)
    postData.append("&city=\(obj.City)".data(using: String.Encoding.utf8)!)
    postData.append("&pincode=\(obj.ZipCode)".data(using: String.Encoding.utf8)!)
    postData.append("notes=\(obj.remarks)".data(using: String.Encoding.utf8)!)
    postData.append("&userimg=\(obj.image)".data(using: String.Encoding.utf8)!)
    postData.append("&catid=0".data(using: String.Encoding.utf8)!)
    postData.append("&labphone=\(obj.WorkNum)".data(using: String.Encoding.utf8)!)
    postData.append("&phonecontactidentifier=\(obj.identifier)".data(using: String.Encoding.utf8)!)
    
    return postData
}
/*          var postData = NSMutableData(data: "userid=9327005120".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&deleteuser=a".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&profileid=12356".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&name=Ankit".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&contact=123654123".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&otherphone=".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&email=".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&address=".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&city=".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&pincode=".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("¬es=".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&userimg=".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&catid=0".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&labphone=".dataUsingEncoding(NSUTF8StringEncoding)!)
 postData.appendData("&phonecontactidentifier=".dataUsingEncoding(NSUTF8StringEncoding)!)*/
/*{"userid" : "9327005120",
"deleteuser" : "a",
"profileid" : "11111",
"name"   : "Dhahanjay",
"contact" : "9033102456",
"otherphone"  : "9876543210",
"email" : "dan@gmail.com",
"address"  : "30 , dutt nagar nadiad",
"city" : "nadiad",
"pincode" : "387002",
"notes" : "tesintg WS",
"userimg" : "google.com/aa",
"catid"  : "0"}
*/
