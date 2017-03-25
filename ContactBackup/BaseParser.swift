//
//  BaseParser.swift
//  ContactFetchSwift
//
//

import UIKit

class BaseParser: NSObject {

    func performData (_ res_data : Data) -> BaseModel
    {
        return BaseModel()
    }
    
    func getParser (_ res_data : Data)->NSMutableArray
    {
        return NSMutableArray()
    }
    
}
