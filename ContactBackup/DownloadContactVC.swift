//
//  DownloadContactVC.swift
//  ContactBackup
//
//

import UIKit

class DownloadContactVC: BaseViewController ,UITextFieldDelegate {

    @IBOutlet weak var Registerbtn: UIButton!
    @IBOutlet weak var txt_profile_id: UITextField!
    
    var isRegisterd : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setMyView()
    {
        let view = UserDefaults.standard.value(forKey: "isView") as! String
        
        if view == "Tabbar"
        {
            isRegisterd = true
        }
        else if view == "Registration"
        {
            isRegisterd = false
            Registerbtn.isHidden = false
        }
      
        setView()
    }
    func setView()
    {
        if isRegisterd
        {
            Registerbtn.isHidden = true
        }
        else
        {
            let uid_random = "\(Int(arc4random_uniform(6)))" as String
            UserDefaults.standard.setValue(uid_random, forKey: "userid")
            UserDefaults.standard.synchronize()
        }
    }
    
   
    @IBAction func Click_RegisterBtn(_ sender: AnyObject)
    {
        let register = storyboard?.instantiateViewController(withIdentifier: "RegistrationVC")
        UserDefaults.standard.setValue(nil, forKey: "userid")
        UserDefaults.standard.synchronize()
        self.present(register!, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        setMyView()
    }
  
   
    
    @IBAction func Click_reqDownlodBtn(_ sender: AnyObject)
    {
       Validation()
        self.txt_profile_id.text = ""
    }
    
      func Validation()
    {
      if validateString(txt_profile_id.text!)
       {
          SendReqForDownload()
       }
        else
      {
        ShowErrorlabel("Enter valid Profile ID")
        
        }
        resignmyView()
    }
    func SendReqForDownload()
    {
        let obj = BaseModel()
        obj.parameter = NSMutableArray()
        var dic = NSMutableDictionary()
        dic.setValue("userid", forKey: "key")
        dic.setValue(UserDefaults.standard.value(forKey: "userid"), forKey: "value")
        obj.parameter?.add(dic)
        
        dic = NSMutableDictionary()
        dic.setValue("profileid", forKey: "key")
        dic.setValue(self.txt_profile_id.text, forKey: "value")
        obj.parameter?.add(dic)
        
        let req = Req_DowloadReq()
        req.sendRequest(obj, objViewController: self)
    }
    
    
    override func onReply(_ res_data: Data, objParser: BaseParser)
    {
        if objParser .isKind(of: Parser_DonloadReq.self)
        {
            let obj = objParser.performData(res_data)
            if obj.resposeStatus == 0
            {
                if obj.errorCode == "0"
                {
                    ShowErrorlabel("Request for contact download is received successfully.")
                    let downlod_bg = DownloadContactBG()
                    downlod_bg.DownloadContacts()
                }
                else
                {
                    self.ShowErrorlabel("Unable to send contact download request,Pleas try again later")
                }
            }
            else
            {
                self.getDataNil()
            }
            
        }
    }
    
   
   

    func resignmyView()
    {
        self.txt_profile_id.resignFirstResponder()
    }
    func nilView()
    {
        self.txt_profile_id.text = "" 
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        resignmyView()
        return true
    }
}
