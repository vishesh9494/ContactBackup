//
//  PageContentViewController.swift
//  ContactBackup
//
//

import UIKit

class PageContentViewController: BaseViewController
{
    var pageIndex: Int?
    var titleText : String!
    var imageName : String!
    
    @IBOutlet weak var btn_skipoutlet: UIButton!
    @IBOutlet weak var bkImageView: UIImageView!
    
    @IBAction func btn_skipClick(_ sender: AnyObject)
    {
        performSegue()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.bkImageView.image = UIImage(named: imageName)
       // self.heading.text = self.titleText
        //self.heading.alpha = 0.1
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
//            self.heading.alpha = 1.0
        })
        
        if (self.pageIndex == 0)
        {
            self.btn_skipoutlet.isHidden = true;
        }
        else
        {
            self.btn_skipoutlet.isHidden = false;
            self.btn_skipoutlet.layer.borderColor=UIColor.white.cgColor
            self.btn_skipoutlet.layer.borderWidth=1.5
            self.btn_skipoutlet.layer.cornerRadius=4
        }
        
    }
    
    func performSegue()
    {
        self.performSegue(withIdentifier: "Start", sender: self)
    }
}
