//
//  JSONDecoder+APIDateDecoding.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {

    static let apiDecodingStrategy = custom {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"

        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = formatter.date(from: string) {
            return date
        }
        //if we want to support more formats, we just add them here, before throwing an error
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}

