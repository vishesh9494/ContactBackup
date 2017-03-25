//
//  SettingVC.swift
//  ContactBackup
//
//

import UIKit

class SettingVC: BaseViewController
{
    @IBOutlet weak var view_Aboutus: UIView!
    @IBOutlet weak var view_logout: UIView!
    @IBOutlet weak var View_reset: UIView!
    var Sqlite = DatabaseManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setMyView()
        designView()
    }
    
    func designView() -> Void
    {
        self.view_logout.layer.cornerRadius = 3.0
        self.view_Aboutus.layer.cornerRadius = 3.0
        self.View_reset.layer.cornerRadius = 3.0
        
        self.view_logout.layer.borderColor = UIColor.gray.cgColor
        self.view_Aboutus.layer.borderColor = UIColor.gray.cgColor
        self.View_reset.layer.borderColor = UIColor.gray.cgColor
        
        self.view_logout.layer.borderWidth = 1.0
        self.view_Aboutus.layer.borderWidth = 1.0
        self.View_reset.layer.borderWidth = 1.0
    }
    
    func setMyView()
    {
        let tapForReset = UITapGestureRecognizer.init(target: self, action: #selector(SettingVC.TaptoReset(_:)))
        let tapForLogout = UITapGestureRecognizer.init(target: self, action: #selector(SettingVC.TaptoLogout(_:)))
        let tapForAboutUs = UITapGestureRecognizer.init(target: self, action: #selector(SettingVC.taptoAboutus(_:)))
        
        View_reset.addGestureRecognizer(tapForReset)
        view_logout.addGestureRecognizer(tapForLogout)
        view_Aboutus.addGestureRecognizer(tapForAboutUs)
        
    }
    func TaptoReset(_ recognizer: UITapGestureRecognizer)
    {
       let obj = BaseModel()
        obj.parameter = NSMutableArray()
        let dict = NSMutableDictionary()
        dict.setValue("userid", forKey: "key")
        dict.setValue(UserDefaults.standard.value(forKey: "userid"), forKey: "value")
        obj.parameter?.add(dict)
        let request = Req_Reset()
        request.sendRequest(obj, objViewController: self)
        
    }
    func TaptoLogout(_ recognizer:UITapGestureRecognizer)
    {
    let alert = UIAlertController.init(title: nil, message: "Are you sure you want to logout?", preferredStyle: .alert)
        let aceptbtn = UIAlertAction.init(title: "Yes", style: .default) { (ACTION) -> Void in
            
            self.logout()
        }
        let cancelbtn = UIAlertAction.init(title: "No", style: .cancel) { (ACTION) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(aceptbtn)
        alert.addAction(cancelbtn)
        self.present(alert, animated: true, completion: nil)
    }
    func logout()
    {
        if Sqlite.ClearTableData()
        {
            UserDefaults.standard.setValue(nil, forKey: "userid")
            UserDefaults.standard.setValue("Tabbar", forKey: "isView")
            UserDefaults.standard.synchronize()
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "LaunchScreen") as UIViewController
            self.present(initialViewController, animated: true, completion: nil)
        }
        else
        {
          ShowErrorlabel("Unable to logout,Please try again later.")
        }
    }
    func taptoAboutus(_ recognizer:UITapGestureRecognizer)
    {
        
    }
    
    override func onReply(_ res_data: Data, objParser: BaseParser)
    {
        if objParser .isKind(of: Parser_Reset.self)
        {
            let obj = objParser.performData(res_data)
            if obj.resposeStatus == 0
            {
                if obj.errorCode == "0"
                {
                   if Sqlite.ClearTableData()
                   {
                      self.ShowErrorlabel("Your all contacts are reseted successfully.")
                   }
                   else
                   {
                    self.ShowErrorlabel("Unable to reset your contacts,Please try again later.")
                   }
                }
                else
                {
                    self.ShowErrorlabel(obj.errorCode!)
                }
            }
            else
            {
                self.getDataNil()
            }
        }
    }
    
    @IBAction func btn_backClick(_ sender: AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
    }    
}
