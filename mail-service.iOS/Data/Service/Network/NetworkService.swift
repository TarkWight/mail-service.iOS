//
//  NetworkService.swift
//  mail-service.iOS
//
//  Created by HITSStudent on 23.06.2024.
//


import Foundation
import Alamofire
import Combine

final class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "http://etbx.ru:7070/"
    private var token: String?

    func setToken(_ token: String) {
        self.token = token
    }

    func requestWithoutToken<T: Encodable>(endpoint: String, method: HTTPMethod, parameters: T) -> AnyPublisher<Data, AFError> {
        let url = baseURL + endpoint
        return AF.request(url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .publishData()
            .value()
            .eraseToAnyPublisher()
    }

    func requestWithToken<T: Encodable>(endpoint: String, method: HTTPMethod, parameters: T) -> AnyPublisher<Data, AFError> {
        guard let token = token else {
            fatalError("Token is not set")
        }

        let url = baseURL + endpoint
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        return AF.request(url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .publishData()
            .value()
            .eraseToAnyPublisher()
    }
    
    func register(user: UserRegistrationModel) -> AnyPublisher<String, Error> {
        let registrationRequest = RegistrationRequest(
            name: user.name,
            surname: user.surname,
            birthday: user.birthday,
            gender: user.gender,
            mail: user.login,
            phoneNum: user.phoneNum,
            password: user.password
        )

        return requestWithoutToken(endpoint: "register", method: .post, parameters: registrationRequest)
            .tryMap { data in
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Server response JSON: \(json)")
                } else {
                    print("Failed to parse server response")
                }
                
                let response = try JSONDecoder().decode(RegistrationResponse.self, from: data)
                return response.token
            }
            .eraseToAnyPublisher()
    }
    
    func login(user: UserAuthorizationModel) -> AnyPublisher<String, Error> {
        let loginRequest = LoginRequest(
            email: user.email + "@pmc-python.ru",
            password: user.password
            )
            
        
            return requestWithoutToken(endpoint: "login", method: .post, parameters: loginRequest)
                .tryMap { data in
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print("Server response JSON: \(json)")
                    } else {
                        print("Failed to parse server response")
                    }
                    
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    return response.token
                }
                .eraseToAnyPublisher()
        }
}

struct RegistrationResponse: Decodable {
    let token: String

    private enum CodingKeys: String, CodingKey {
        case token = "Token"
    }
}

struct LoginResponse: Decodable {
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case token = "Token"
    }
}

