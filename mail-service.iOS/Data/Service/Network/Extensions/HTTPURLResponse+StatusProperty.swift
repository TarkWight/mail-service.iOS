//
//  HTTPURLResponse+StatusProperty.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import Foundation

extension HTTPURLResponse {
    public var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
    }
}
