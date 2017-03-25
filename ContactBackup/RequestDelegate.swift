//
//  RequestDelegate.swift
//  ContactFetchSwift
//
//

import Foundation

protocol RequestDelegate
{

    func onReply(_ res_data : Data, objParser : BaseParser) -> Void
    func connectionError(_ req_model : BaseModel) -> Void
    func getDataNil() -> Void
}
