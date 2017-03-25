//
//  BaseRequest.swift
//  ContactFetchSwift
//
//

enum showLoading {
    case show,
    hide
}

import UIKit

class BaseRequest: NSObject
{
    var loading_view : SSLoadingView?
    var requestDelegate : RequestDelegate?
    var valShowloading = showLoading.show
    var obj_baseViewController : BaseViewController?
    var obj_reqModel : BaseModel?
    var obj_baseParser : BaseParser?
    var  url : URL?
    var HTTPMethod : String?
    
    func sendRequestToServer(_ reqDic : NSDictionary) -> Void
    {
        if valShowloading == showLoading.show
        {
            loading_view = SSLoadingView.init(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            loading_view?.center = (obj_baseViewController?.view.center)!
            loading_view?.showLoading((obj_baseViewController?.view)!)
        }
        
        do{                       
            
            let  objRequest  = NSMutableURLRequest(url: url!)
            
            objRequest.httpMethod = self.HTTPMethod!
            objRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            objRequest.timeoutInterval = 20
            
            let  data : Data  = try JSONSerialization.data(withJSONObject: reqDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            if self.HTTPMethod == "POST"
            {
                objRequest.httpBody = data                
            }
            
            let  session : URLSession = URLSession.shared
            
            let task = session.dataTask(with: objRequest as URLRequest, completionHandler: {data, response, error -> Void in
                
                DispatchQueue.main.async(execute: {
                    self.loading_view?.hideLoading()
                    
                    if error == nil
                    {
                        self.printDictionary(data!)
                    }
                    else
                    {
                        self.requestDelegate?.connectionError(self.obj_reqModel!)
                    }
                })
                
            })
            task.resume()
        }catch _ {
            print("exception is)")
        }
    }
    
    
    func printDictionary(_ res_data:Data) -> Void
    {
        self.requestDelegate?.onReply(res_data, objParser: self.obj_baseParser!)
        print("res_dic is \(res_data)")
        
        /*do{
           
            self.requestDelegate?.onReply(res_data, objParser: self.obj_baseParser!)
            print("res_dic is \(res_data)")
            
        }catch
        {
            self.requestDelegate?.getDataNil()
            print("Exception is \(error)")
        }*/
        
    }

    func sendRequest(_ objModel : BaseModel?, objViewController : BaseViewController) -> Void
    {
        
    }
}
