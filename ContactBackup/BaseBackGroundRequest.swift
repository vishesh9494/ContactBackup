//
//  BaseBackGroundRequest.swift
//  ContactFetchSwift
//

//

import UIKit

class BaseBackGroundRequest: NSObject
{
    
    var requestDelegate : BGOnReplyDelegate?
    var obj_reqModel : BaseModel?
    var obj_baseParser : BasebackGroundParser?
    var  url : URL?
    var HTTPMethod :String = "GET"
    
    func sendRequestToServer(_ reqDic : NSDictionary) -> Void
    {
        do
        {
            let  objRequest  = NSMutableURLRequest(url: url!)
            
            objRequest.httpMethod = HTTPMethod
            objRequest.timeoutInterval = 20
            objRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let  data : Data  = try JSONSerialization.data(withJSONObject: reqDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if self.HTTPMethod == "POST"
            {
              objRequest.httpBody = data
            }

            
            
            let  session : URLSession = URLSession.shared
            
            let task = session.dataTask(with: objRequest as URLRequest, completionHandler: {data, response, error -> Void in
                
                DispatchQueue.main.async(execute: {
                        if error == nil
                        {
                           self.requestDelegate?.onReply(data!, objParser:self.obj_baseParser!, req_model: self.obj_reqModel!)
                        }
                        else
                        {
                            self.requestDelegate?.connectionError(self.obj_reqModel!)
                        }
                })
            })
            task.resume()
        }
        catch
        {
            print("Exception in BGBase Request \(error)")
        }
    }
    func sendRequest(_ objModel : BaseModel?, objViewController : BGBaseHandler) -> Void
    {
        
    }
    func uploadImageForPHP(_ imgename : UIImage ,name : String) -> Void
    {
        //        let url = NSURL(string:"http://192.168.1.5/webservice_php/fileupload.php")
        let url = URL(string:"http://minesh.site.aplus.net/Chainz/imageupload.php")
        
        
        let objRequest = NSMutableURLRequest(url: url!)
        
        let boundary = "xxxxBoundaryStringxxxx"
        
        let contentType = "multipart/form-data; boundary="+boundary
        
        let body = NSMutableData.init()
        
        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"fileUpload\"; filename=\"\(name).png\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
        
        let imageData = UIImagePNGRepresentation(imgename)
        
        body.append(imageData!)
        
        body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        objRequest.httpBody = body as Data
        objRequest.httpMethod = "Post"
        objRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        objRequest.timeoutInterval = 60
        
        let  session : URLSession = URLSession.shared
        
        let task = session.dataTask(with: objRequest as URLRequest, completionHandler: {data, response, error -> Void in
            
            DispatchQueue.main.async(execute: {
                     //  self.printDictionary(data!)
                    do{
                        if error == nil
                        {
                            let res_dic : NSDictionary  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                            print("res_dic is \(res_dic)")
                        }
                        else
                        {
                            print("error in image upload",error)
                        }
                        
                        
                    }catch
                    {
                        print("Exception is \(error)")
                    }
            })
        })
        task.resume()
        
    }
    func printDictionary(_ res_data:Data) -> Void
    {
        do{
            
            let res_dic : NSDictionary  = try JSONSerialization.jsonObject(with: res_data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            print("res_dic is \(res_dic)")
            
        }catch
        {
            print("Exception is \(error)")
        }
        
    }
    
    func  downloadImag(_ imgname : String)
    {
        let fileURL = URLGenerator.GetImageURl(imgname)
        let request = NSMutableURLRequest.init(url: fileURL, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30)
        let  session : URLSession = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            DispatchQueue.main.async(execute: {
                    if error == nil
                    {
                        self.SaveImageLocally(data!, imgName: imgname)
                    }
                    else
                    {
                        print("error is",error)
                    }
            })
        })
        task.resume()

        }
    

    func SaveImageLocally(_ imgData:Data,imgName : String) -> Bool
        {
               var success: Bool = false
                if !((try? imgData .write(to: URL(fileURLWithPath: GetImagePath(imgName)), options: [.atomic])) != nil)
                {
                    print("Fail to Store image.")
                    success = false
                }
                else
                {
                    print("Success")
                    success = true
                }
                return success
            
        }

    func GetImagePath(_ imgName:String)->String
    {
        let documents =  try!FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let fileUrl = documents.appendingPathComponent("\(imgName).png")
        
        return fileUrl.path
    }

   /* NSURL *fileURL = [NSURL URLWithString:[imageArray objectAtIndex:i]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
    if (!error && data.length>0)
    {
    UIImage *image = [[UIImage alloc] initWithData:data];
    [imgview setImage:image];
    }
    else
    {
    [imgview setImage:[UIImage imageNamed:@"pro1.png"]];
    }
    }];*/
    
    func sendRequestToServerwithFormData(_ postData : NSMutableData) -> Void
    {
        do
        {
            let headers = [ "content-type": "application/x-www-form-urlencoded" ]
            
            
            let request =  NSMutableURLRequest(url:self.url!,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 20.0)
            request.httpMethod = self.HTTPMethod
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session =  URLSession.shared
            let dataTask =  session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil)
                {
                    print(error)
                }
                else
                {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    self.requestDelegate?.onReply(data!, objParser: self.obj_baseParser!, req_model: self.obj_reqModel!)
                }
            })
            
            dataTask.resume()
        }
        
    }
   
    
}
