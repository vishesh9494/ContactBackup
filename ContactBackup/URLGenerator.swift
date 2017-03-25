//
//  URLGenerator.swift
//  ContactFetchSwift
//
//

import UIKit

class URLGenerator: NSObject
{
    var  urlString = ""
   static let  Serviceip = "http://arundataprocessing.com"
    
    var URLString : NSString
    {
        set(url)
        {
            self.URLString = url
        }
        get
        {
            return self.URLString
        }
    }
    
    static func GetMethodForContacts(_ MethodName : String,Parameter:NSMutableArray)-> URL
    {
        var urlstr = "\(Serviceip)/Phase2WSC/Contact/\(MethodName).php?"
        for i in 0 ..< Parameter.count
        {
            
            let key = (Parameter [i] as AnyObject).value(forKey: "key") as! String
            let value = (Parameter [i] as AnyObject).value(forKey: "value") as! String
            if i > 0
            {
                urlstr += "&\(key)=\(value)"

            }
            else
            {
                urlstr += "\(key)=\(value)"

            }
            
        }
        return URL.init(string: urlstr)!
    }
    
    static func GetMethodForRegistration(_ MethodName : String,Parameter : NSMutableArray)-> URL
    {
        var urlstr = "\(Serviceip)/Phase2WSC/Register/\(MethodName)?.php"
        
        for i in 0 ..< Parameter.count
        {
            
            let key = (Parameter [i] as AnyObject).value(forKey: "key") as! String
            let value = (Parameter [i] as AnyObject).value(forKey: "value") as! String
            if i > 0
            {
                urlstr += "&\(key)=\(value)"
                
            }
            else
            {
                urlstr += "\(key)=\(value)"
                
            }
            
        }

        return URL.init(string: urlstr)!
    }
    
    static func GetMethodForUplodContact()-> URL
    {
        let urlstr = "\(Serviceip)/Chainz/chainzadd.php"
        return URL.init(string: urlstr)!
    }
    static func GetImageURl(_ ImgName : String)->URL
    {
        let urlstr = "\(Serviceip)/Chainz/uploads/\(ImgName).png"
        return URL.init(string: urlstr)!
    }
    
    
    //http://minesh.site.aplus.net/Phase2WSC/Login/verifyReset
    //http://minesh.site.aplus.net/Chainz/uploads
    
    static func GETMethodForReset(_ MethodName: String,Parameter : NSMutableArray) ->URL
    {
        var urlstr = "\(Serviceip)/Phase2WSC/Login/\(MethodName).php?"
        
        for i in 0 ..< Parameter.count
        {
            
            let key = (Parameter [i] as AnyObject).value(forKey: "key") as! String
            let value = (Parameter [i] as AnyObject).value(forKey: "value") as! String
            if i > 0
            {
                urlstr += "&\(key)=\(value)"
                
            }
            else
            {
                urlstr += "\(key)=\(value)"
                
            }
            
        }
        
        return URL.init(string: urlstr)!

    }
    
 }
