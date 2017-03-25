//
//  ContactListVC.swift
//  ContactBackup
//
//
import UIKit

enum Selection
{
    case rowSelection
    case logPress
}

class ContactListVC: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var EmotyView: UIView!
    @IBOutlet weak var List_tblView: UITableView!
   
    @IBOutlet weak var ViewTable: UIView!
    @IBOutlet weak var txt_search: UITextField!
    var SearchTable :UITableView?
    var BGView: UIView?
    var sqlite = DatabaseManager()
    var Objects : NSMutableArray = []
    var selctedPerson = Person_Model()
    var isSelection = Selection.rowSelection
    var filterArray : NSMutableArray = []
    
    var notification : NotificationCenter?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        notification = NotificationCenter()
        notification?.setupNotification()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.GetContactList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldValueChange(_ sender: AnyObject)
    {
        let str = self.txt_search.text! as NSString
        if str.length > 0
        {
            let resultPredicate = NSPredicate(format: "(FirstName contains[c] %@) OR (lastName beginswith[c] %@)",txt_search.text!,txt_search.text!)
            filterArray = Objects.mutableCopy() as! NSMutableArray
            filterArray.filter(using: resultPredicate)
            if filterArray.count <= 0
            {
                hidViewForSearch()
                ShowErrorlabel("Sorry, no results were found.")
            }
            else
            {
                SetViewForSearch()
            }
        }
        else
        {
            hidViewForSearch()
            List_tblView.reloadData()
        }
        
    print("\(filterArray)")
    }

   func SetViewForSearch()
   {
    if SearchTable != nil
    {
        hidViewForSearch()
    }
     BGView = UIView.init(frame: CGRect(x: 0, y: 0, width: ViewTable.frame.size.width, height: ViewTable.frame.size.height))
    BGView?.backgroundColor = Util_Color.GetTransViewColor()
    SearchTable = UITableView.init(frame: CGRect(x: 0,y: 0, width: (BGView?.frame.size.width)!, height: (BGView?.frame.size.height)!/2))
    SearchTable?.dataSource = self
    SearchTable?.delegate = self
    SearchTable?.sectionFooterHeight = 1
    
    //SearchTable?.backgroundColor = Util_Color.GetSearchTableBGColor()
    //SearchTable?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "search")
    
    BGView?.addSubview(SearchTable!)
    ViewTable.addSubview(BGView!)
    SearchTable?.reloadData()
   }
    
   func hidViewForSearch()
   {
     BGView?.removeFromSuperview()
     BGView = nil
    }
    
    func GetContactList()->Void
    {
         Objects = sqlite.Select("select * from ContactList")
        if Objects.count > 0
        {
            EmotyView.isHidden = true
        }
        else
        {
            EmotyView.isHidden = false
        }
        List_tblView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rows : Int = 0
        if tableView == List_tblView
        {
            rows = Objects.count
        }
        else
        {
          rows = filterArray.count
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView == List_tblView
        {
            let  cell = List_tblView.dequeueReusableCell(withIdentifier: "contactList", for: indexPath) as! ContactListCell
            
            let model = Objects[indexPath.row] as? Person_Model
            let name = model!.FirstName + " \(model!.lastName)"
            cell.lbl_Name.text = name
            cell.lbl_number.text = model?.MobNum
            
            cell.ProfilePick.layer.cornerRadius = cell.ProfilePick.frame.width/2
            cell.ProfilePick.layer.masksToBounds = true
            
            if model?.image == "true"
            {
                cell.ProfilePick.image = UIImage.init(contentsOfFile: GetImagePath((model?.profile_id)!))
            }
            else
            {
                cell.ProfilePick.image = UIImage.init(named: "noImg.png")
            }
            let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(ContactListVC.LogPresToUpdateDelete(_:)))
            
            cell.addGestureRecognizer(longPress)
            
            return cell
        }
        else
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "search") as UITableViewCell!
            
            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "CELL")
            }
            cell?.backgroundColor = Util_Color.GetSearchTableCellBGColor()
            let model = filterArray[indexPath.row] as? Person_Model
            let name = model!.FirstName + " \(model!.lastName)"
            cell?.textLabel?.text = name
            cell?.detailTextLabel?.text = model?.MobNum
            if model?.image != ""
            {
                cell?.imageView?.image = UIImage.init(contentsOfFile: GetImagePath((model?.image)!))
            }
            else
            {
                cell?.imageView?.image = UIImage.init(named: "noImg.png")
            }
            
            return cell!            
        }
      

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      
         selctedPerson = Objects[indexPath.row] as! Person_Model
        isSelection = .rowSelection
         self.performSegue(withIdentifier: "contact_detail", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let view1 = UIView()
        view1.backgroundColor = UIColor.white
        return view1
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contact_detail"
        {
          let vc2 = segue.destination as? ViewContactVC
            vc2?.obj = selctedPerson
            vc2?.isFrom = isSelection
        }
    }
    
    func LogPresToUpdateDelete(_ recognizer:UILongPressGestureRecognizer)
    {
        let selectedDCell = recognizer.view as! UITableViewCell
        
        let index = List_tblView.indexPath(for: selectedDCell)
        
        
        
        let sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let Upadatbtn = UIAlertAction.init(title: "Edit", style: .default) { (ACTION) -> Void in
            self.isSelection = .logPress
            self.selctedPerson = self.Objects[(index?.row)!] as! Person_Model
            self.performSegue(withIdentifier: "contact_detail", sender: self)
        }
        let Deletbtn = UIAlertAction.init(title: "Delete", style: .default) { (ACTION) -> Void in
            let obj = self.Objects[(index?.row)!] as! Person_Model
           
            let alert = UIAlertController.init(title: nil, message: "Are you sure you want to delete this contact ?", preferredStyle: .alert)
            let cancelBtn = UIAlertAction.init(title: "NO", style: .cancel, handler: { (ACTION) -> Void in
                alert.dismiss(animated: true, completion: nil)
            })
            let ConfirmBtn = UIAlertAction.init(title: "YES", style: .default, handler: { (ACTION) -> Void in
               
                if self.sqlite.DeleteContact(obj.contact_id)
                {
                    self.Objects.removeObject(at: (index?.row)!)
                    if self.Objects.count > 0
                    {
                        self.EmotyView.isHidden = true
                    }
                    else
                    {
                        self.EmotyView.isHidden = false
                    }
                    self.List_tblView.reloadData()
                }
            })
            alert.addAction(cancelBtn)
            alert.addAction(ConfirmBtn)
            self.present(alert, animated: true, completion: nil)
        }
        let CancelBtn = UIAlertAction.init(title: "Cancel", style: .destructive) { (ACTION) -> Void in
            sheet.dismiss(animated: true, completion:nil)
        }
        sheet.addAction(Upadatbtn)
        sheet.addAction(Deletbtn)
        sheet.addAction(CancelBtn)
        self.present(sheet, animated: true, completion: nil)
        
//        let resultPredicate = NSPredicate(format: "(FirstName contains[c] %@) OR (symbol beginswith[c] %@)", "jdkljsalk","dsadsa")
//        Objects.filterUsingPredicate(resultPredicate)
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
       // SetViewForSearch()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
       textField .resignFirstResponder()
        return true
    }
}
