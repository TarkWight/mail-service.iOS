//
//  CombineAPIClient.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//

import Combine
import Foundation

public protocol CombineAPISessionProtocol {
    func apiDataTaskPublisher(with request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError>
}

public protocol APIRequestProtocol {
    associatedtype ResponseType: Decodable

    var acceptableResponseCodes: [HTTPStatusCode] { get }

    var cachePolicy: NSURLRequest.CachePolicy { get }
    var endpoint: String { get }
    var queryItems: [URLQueryItem] { get }
    func generateURLRequest() throws -> URLRequest
}

public protocol CombineAPIClientProtocol {
    init(session: CombineAPISessionProtocol?)
    func execute<T: APIRequestProtocol>(_ request: T) -> AnyPublisher<T.ResponseType, Error>
    func execute<T: APIRequestProtocol>(_ request: T, queue: DispatchQueue) -> AnyPublisher<T.ResponseType, Error>
}

final class APIClientEmptyResponse: Decodable {}

final class CombineAPIClient: CombineAPIClientProtocol {
    private let session: CombineAPISessionProtocol?

    public init(session: CombineAPISessionProtocol? = nil) {
        self.session = session
    }

    public func execute<T: APIRequestProtocol>(_ request: T) -> AnyPublisher<T.ResponseType, Error> {
        return execute(request, queue: .main)
    }

    public func execute<T: APIRequestProtocol>(_ request: T, queue: DispatchQueue) -> AnyPublisher<T.ResponseType, Error> {

        var concreteRequest: URLRequest
        do {
            concreteRequest = try request.generateURLRequest()
        } catch let error {
            return AnyPublisher(Fail(outputType: T.ResponseType.self, failure: error))
        }

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .apiDecodingStrategy

        let apiSession = session ?? URLSession.shared
        return apiSession.apiDataTaskPublisher(with: concreteRequest)
            .tryMap {
                guard $0.response.mimeType == "application/json" else {
                    throw APIError.invalidResponseType
                }
                guard let dataResponse = $0.response as? HTTPURLResponse, let status = dataResponse.status else {
                    throw APIError.invalidResponseType
                }

                if request.acceptableResponseCodes.contains(status) {
                    if let response = APIClientEmptyResponse() as? T.ResponseType {
                        return response
                    }
                    do {
                        let result = try jsonDecoder.decode(T.ResponseType.self, from: $0.data)
                        return result
                    } catch let error {
                        print("error: \(error)")
                        throw error
                    }
                } else {
                    throw NSError(domain: "CombineAPIClient", code: status.rawValue, userInfo: nil)
                }
            }
            .mapError({ (error) -> Error in
                guard error as? APIError == nil else {
                    return error
                }
                let converted = error as NSError
                if [NSURLErrorNotConnectedToInternet, NSURLErrorCannotFindHost, NSURLErrorTimedOut].contains(converted.code) {
                    return APIError.deviceOffline
                }
                return APIError.invalidJson
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: queue)
            .eraseToAnyPublisher()
    }
}

