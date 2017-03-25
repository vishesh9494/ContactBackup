//
//  BaseViewController.swift
//  ContactBackup
//
//

import UIKit

class BaseViewController: UIViewController,RequestDelegate
{
    var lbl_net : UILabel?
    var lbl_view : UIView?
    var isview : isFromView?
    
    func connectionError(_ req_model: BaseModel)
    {
      ShowErrorlabel("Please check your internet connection or try again later.")
        
    }
    
    func onReply(_ res_data: Data, objParser: BaseParser)
    {
        
    }
    
    func getDataNil()
    {
      ShowErrorlabel("A data mismatch has occurred, please contact the admin.")
    }
   
    func GetImagePath(_ imgName:String)->String
    {
        let documents =  try!FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let fileUrl = documents.appendingPathComponent("\(imgName).png")
        
        return fileUrl.path
    }
    func SaveImageTopath(_ path:String ,Image:Data)->Bool
    {
        var success: Bool = false
        if !((try? Image .write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil)
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
   
    func ShowErrorlabel(_ Title : String)
    {
        if lbl_net != nil
        {
            hidLabel()
        }
        lbl_view = UIView.init(frame: CGRect(x: 0, y: view.frame.size.height - 60, width: view.frame.size.width, height: 60))
        lbl_view?.backgroundColor = Util_Color.GetErrorLabelBG()
        lbl_net = UILabel.init(frame: CGRect(x: 10, y: 0, width: (lbl_view?.frame.width)! - 20, height: (lbl_view?.frame.size.height)!))
        lbl_net?.textColor = Util_Color.GetWhiteColor()
        lbl_net?.font = UIFont.systemFont(ofSize: 12)
        lbl_net?.textAlignment = NSTextAlignment.left
        lbl_net?.numberOfLines = 0
        lbl_net?.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl_net?.adjustsFontSizeToFitWidth
        lbl_net?.text = Title
        lbl_view?.addSubview(lbl_net!)
        UIApplication.shared.keyWindow?.addSubview(lbl_view!)
        self.perform(#selector(BaseViewController.hidLabel), with: nil, afterDelay: 3.0)
        
    }
    func hidLabel()
    {
        lbl_view?.removeFromSuperview()
        lbl_view = nil
    }
    func validateString(_ str: String)->Bool
    {
        var result : Bool?
        let str1 = str.trimmingCharacters(in: CharacterSet.whitespaces)
        let whitespace = CharacterSet.whitespacesAndNewlines
        let trimmed = str1.trimmingCharacters(in: whitespace) as NSString
        if trimmed.length > 0
        {
            result = true
        }
        else
        {
            result = false
        }
        return result!
    }
 }


