//
//  RegistrationVC.swift
//  ContactBackup
//
//

enum isFromView
{
    case registration
    case tabbar
}

import UIKit

class RegistrationVC: BaseViewController,UITextFieldDelegate, UIAlertViewDelegate {

    @IBOutlet weak var hgt_ContainerView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtContainer_view: UIView!
    @IBOutlet weak var txt_mobile: UITextField!
    @IBOutlet weak var btn_next: UIView!
    var flag:Bool = true
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let sheet=UIAlertController.init(title: nil, message: "Please Note down your credentials for further use", preferredStyle: .alert)
        let OK=UIAlertAction.init(title: "OK", style: .default){
            (ACTION) -> Void in
            sheet.dismiss(animated: true, completion: nil)
            self.view.alpha=1.0
        }
        sheet.addAction(OK)
        self.present(sheet, animated: true, completion: nil)
        self.view.alpha=0.5
        
        
    }

    @IBAction func Click(_ sender: AnyObject)
    {
        self.performSegue(withIdentifier: "Skip", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //self.txt_mobile.text = "9327005120"
    }
    @IBAction func Click_ConfirmBtn(_ sender: AnyObject)
    {
        validatation()
    }
    
    func validatation()
    {
        if validateString(self.txt_mobile.text!)
        {
            let str = self.txt_mobile.text!
            if str.characters.count == 10
            {
                var check=0;
                var counter=0
                for counter in 0 ... (self.txt_mobile.text?.characters.count)! - 1 {
                    if(str[(str.index((str.startIndex), offsetBy: counter))]<"0" || str[(str.index((str.startIndex), offsetBy: counter))]>"9"){
                        check=1
                        break
                    }
                }
                if(check==0){
                    self.SendReqForRegistration()
                }
                else{
                    ShowErrorlabel("Enter valid verification code")
                    
                }

                //SendReqForRegistration()
            }
            else
            {
                 ShowErrorlabel("Enter valid  mobile number")
            }
        }
        else
        {
            ShowErrorlabel("Enter valid  mobile number")
        }
        self.txt_mobile.text=""
    }
    func resignMyView()
    {
        txt_mobile.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    func becomeResponder()
    {
        scrollView.setContentOffset(CGPoint(x: 0, y: 140), animated: true)
    }
    
    func textFieldShouldBeginEditing(_ txt_mobile: UITextField) -> Bool
    {
           becomeResponder()
           return true
    }
    func textFieldShouldReturn(_ txt_mobile: UITextField) -> Bool
    {
        resignMyView()
        return true
    }
    
    func setMyView()
    {
        txtContainer_view.layer.cornerRadius = 0.8        
        btn_next.layer.cornerRadius = btn_next.frame.height/2
        btn_next.layer.masksToBounds = true
        hgt_ContainerView.constant = self.view.frame.size.height
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sentOtp"
        {
            let vc2 = segue.destination as! OTP_VC
            vc2.mobNo = self.txt_mobile.text
        }
        else if segue.identifier == "Skip"
        {
           UserDefaults.standard.setValue("Registration", forKey: "isView")
           UserDefaults.standard.synchronize()
        }
    }
    
    func SendReqForRegistration()
    {
       let obj = BaseModel()
        obj.parameter = NSMutableArray()
        let dic = NSMutableDictionary()
        dic.setValue("userid", forKey: "key")
        dic.setValue(self.txt_mobile.text!, forKey: "value")
        obj.parameter?.add(dic)
        
        let req = Req_Registration()
        req.sendRequest(obj, objViewController: self)
    }
    
    
    override func onReply(_ res_data: Data, objParser: BaseParser)
    {
        if objParser .isKind(of: Parser_Registration.self)
        {
             let obj = objParser.performData(res_data)
            if obj.resposeStatus == 0
            {
                if obj.errorCode == "-1"
                {
                    self.performSegue(withIdentifier: "sentOtp", sender: self)
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
    

}
