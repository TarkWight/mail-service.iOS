//
//  APIError.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import Foundation

public enum APIError: Error {
    case invalidUrl
    case invalidRequest
    case invalidResponseType
    case invalidResponseData
    case invalidJson
    case deviceOffline
    case errorCodeTypeMismatch
    case invalidAcceptableResponseCodes
    case urlSessionError
    case unknownError
}
