//
//  CombineAPISession+URLSession.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import Foundation
import Combine

extension URLSession: CombineAPISessionProtocol {
    public func apiDataTaskPublisher(with request: URLRequest) -> AnyPublisher<DataTaskPublisher.Output, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
