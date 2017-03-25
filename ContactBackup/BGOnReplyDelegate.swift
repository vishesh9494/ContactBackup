//
//  BGOnReplyDelegate.swift
//  ContactFetchSwift
//
//

import Foundation

protocol BGOnReplyDelegate
{
    func onReply(_ res_data: Data, objParser:BasebackGroundParser , req_model : BaseModel) -> Void
    func connectionError(_ req_model : BaseModel) -> Void
    func getNilData()->Void
}
