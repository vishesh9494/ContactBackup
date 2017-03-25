//
//  NotificationVC.swift
//  ContactBackup
//
//

import UIKit

class NotificationVC: BaseViewController
{
    @IBOutlet weak var alertTableview: UITableView!
    @IBOutlet weak var view_Empty: UIView!
    var msgArray : NSMutableArray?
    var isMsg : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        setDetail()
        SendReqForAlert()
    }
    override func onReply(_ res_data: Data, objParser: BaseParser)
    {
        if objParser .isKind(of: Parser_notification.self)
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
                    self.ShowErrorlabel("There are no Notifications available for you")
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
            view_Empty.isHidden = true
            alertTableview.reloadData()
        }
        else
        {
            view_Empty.isHidden = false
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
        let request = Req_notification()
        request.sendRequest(obj, objViewController: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (msgArray?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notification", for:indexPath)
        let obj = msgArray![indexPath.row] as! Model_notiification
        cell.textLabel?.text = obj.Message
        return cell
    }
}
