//
//  Util_Color.swift
//  ContactBackup
//
//

import UIKit

class Util_Color: NSObject
{
  static  func GetErrorLabelBG()->UIColor
   {
      return  UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha:0.9)
   }
   
    static func GetWhiteColor()->UIColor
    {
        return UIColor.init(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
    }
    
    static func GetSearchBGViewColor()->UIColor
    {
         return  UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha:0.5)
    }
    static func GetSearchTableBGColor()->UIColor
    {
        return UIColor.init(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.7)
    }
    
    static func GetSearchTableCellBGColor()->UIColor
    {
        return UIColor.init(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.7)
    }
    static func GetBlueolor()->UIColor
    {
        return UIColor.init(red: 13.0/255, green: 101.0/255, blue: 148.0/255, alpha: 0.7)
        //        return UIColor.init(red: 18.0/255, green: 142.0/255, blue: 190.0/255, alpha: 1.0)
    }
    static  func GetTransViewColor()->UIColor
    {
        return  UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
    }
}
