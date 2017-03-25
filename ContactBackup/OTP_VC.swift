//
//  OTP_VC.swift
//  ContactBackup
//
//

import UIKit

class OTP_VC: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbl_msg: UILabel!
    @IBOutlet weak var txtContainer_view: UIView!
    @IBOutlet weak var txt_OTP: UITextField!
    @IBOutlet weak var confirmBtn_view: UIView!
    @IBOutlet weak var hgt_ContainerView: NSLayoutConstraint!
    
    var mobNo :String?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txt_OTP.resignFirstResponder()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setMyView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.txt_OTP.text = ""
    }
    @IBAction func Click_ConfirmOtp(_ sender: AnyObject)
    {
        validation()
    }
    
    @IBAction func Click_Backbtn(_ sender: AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validation()
    {
        var t_OTP=self.txt_OTP.text!
        if validateString(self.txt_OTP.text!)
        {
            
                if((self.txt_OTP.text?.characters.count)!>=5){
                var check=0;
                var counter=0
                for counter in 0 ... (self.txt_OTP.text?.characters.count)!-1 {
                    if(t_OTP[t_OTP.index(t_OTP.startIndex, offsetBy: counter)]<"0" || t_OTP[t_OTP.index(t_OTP.startIndex, offsetBy: counter)]>"9" ){
                        check=1
                        break
                    }
                }
                    if(check==0){
                    self.SendReqForConfirmation()
                    }
                    else{
                        ShowErrorlabel("Enter valid verification code")

                    }
            }
            else{
            ShowErrorlabel("Enter valid verification code")
                }
            txt_OTP.text=""
            
        }
        else
        {
            ShowErrorlabel("Enter valid verification code")
            txt_OTP.text=""
        }
    }
    
    
    func resignMyView()
    {
        txt_OTP.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func becomeResponder()
    {
        scrollView.setContentOffset(CGPoint(x: 0, y: 140), animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        becomeResponder()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        resignMyView()
        return true
    }
    
    func setMyView()
    {
        txtContainer_view.layer.cornerRadius = 0.8
        confirmBtn_view.layer.cornerRadius = confirmBtn_view.frame.height/2
        confirmBtn_view.layer.masksToBounds = true    
        //lbl_msg.text = "Enter the verification code sent to your phone number - \(mobNo)"
        self.hgt_ContainerView.constant = self.view.frame.size.height
    }
    
    func SendReqForConfirmation()
    {
        let obj = BaseModel()
        obj.parameter = NSMutableArray()
        var dic = NSMutableDictionary()
        dic.setValue("userid", forKey: "key")
        dic.setValue(mobNo, forKey: "value")
        obj.parameter?.add(dic)
        
        dic = NSMutableDictionary()
        dic.setValue("verifycode", forKey: "key")
        dic.setValue(txt_OTP.text!, forKey: "value")
        obj.parameter?.add(dic)
        
        let req = Req_OTPConformation()
        req.sendRequest(obj, objViewController: self)
    }
    
    
    override func onReply(_ res_data: Data, objParser: BaseParser)
    {
        if objParser .isKind(of: Parser_OTPConformastion.self)
        {
            let obj = objParser.performData(res_data)
            if obj.resposeStatus == 0
            {
                if obj.errorCode == "-1"
                {
                    UserDefaults.standard.setValue("Tabbar", forKey: "isView")
                    UserDefaults.standard.setValue(mobNo, forKey: "userid")
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "confirm", sender: self)
                }
                else
                {
                    self.ShowErrorlabel("Invalid verification code,Please try gain later.")
                }
            }
            else
            {
                self.getDataNil()
            }
        }
    }

}
