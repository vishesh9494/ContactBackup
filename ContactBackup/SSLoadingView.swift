//
//  SSLoadingView.swift
//  ContactFetchSwift
//
//

import UIKit

class SSLoadingView: UIView
{
    var isShow = false
    
    class var sharedInstance: SSLoadingView
    {
        struct Static
        {
            static let instance: SSLoadingView = SSLoadingView()
        }
        return Static.instance
    }
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        createView()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("This class does not support NSCoding")
    }
    
    func createView()
    {
        self.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        
        let indicator = UIActivityIndicatorView.init()
        indicator.center = self.center
        indicator.startAnimating()
        indicator.color = UIColor.white
        
        self.addSubview(indicator)
        
        let lbl_message = UILabel.init(frame: CGRect(x: 5, y: 52, width: 60, height: 15))
        lbl_message.text = "Loading..."
        lbl_message.adjustsFontSizeToFitWidth = true
        lbl_message.font = UIFont.boldSystemFont(ofSize: 12)
        lbl_message.textColor = UIColor.white
        lbl_message.textAlignment = NSTextAlignment.center
        
        self.addSubview(lbl_message)
    }
    
    func showLoading(_ parent_view : UIView) -> Void
    {
        isShow = true
        parent_view.addSubview(self)
    }
    
    func hideLoading() -> Void
    {
        isShow = false
        self.removeFromSuperview()
    }
    
    func isShowing() -> Bool
    {
        return isShow
    }
    
    
}
