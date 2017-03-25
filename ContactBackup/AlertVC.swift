//
//  AlertVC.swift
//  ContactBackup
//
//

import UIKit

class AlertVC: BaseViewController,UITableViewDataSource
{
    @IBOutlet weak var view_empty: UIView!
    @IBOutlet weak var AlertTableView: UITableView!
    var msgArray : NSMutableArray?
    var isMsg : Bool = false
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        SendReqForAlert()
      
    }
    override func onReply(_ res_data: Data, objParser: BaseParser)
    {
        if objParser .isKind(of: parser_Alert.self)
        {
            let obj = objParser.performData(res_data)
            if obj.resposeStatus == 0
            {
                if obj.errorCode == ""
                {
                    msgArray = obj.msg
                    isMsg = true
                    
                }
                else
                {
                    self.ShowErrorlabel("There are no Alerts for you")
                    isMsg = false
                }
            }
            else
            {
                self.getDataNil()
                isMsg = false
            }
            setDetail()
        }
    }
    func setDetail()
    {
        if isMsg
        {
            view_empty.isHidden = true
            AlertTableView.reloadData()
        }
        else
        {
           view_empty.isHidden = false
        }
    }
    func SendReqForAlert()
    {
        let obj = BaseModel()
        obj.parameter = NSMutableArray()
        let dict = NSMutableDictionary()
        dict.setValue(UserDefaults.standard.value(forKey: "userid"), forKey: "value")
        dict.setValue("userid", forKey: "key")
        obj.parameter?.add(dict)
        let request = Req_Alert()
        request.sendRequest(obj, objViewController: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return (msgArray?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let cell = tableView.dequeueReusableCell(withIdentifier: "alert", for:indexPath)
        let obj = msgArray![indexPath.row] as! Model_notiification
        cell.textLabel?.text = obj.Message
        return cell
    }
    
    @IBAction func btn_backClick(_ sender: AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}
