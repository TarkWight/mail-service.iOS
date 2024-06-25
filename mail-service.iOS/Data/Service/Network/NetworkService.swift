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
    private var token: String? {
        didSet {
            saveTokenToUserDefaults(token)
        }
    }
    
    private init() {
        self.token = UserDefaults.standard.string(forKey: "userToken")
    }
    
    private func saveTokenToUserDefaults(_ token: String?) {
        UserDefaults.standard.set(token, forKey: "userToken")
    }
    
    func setToken(_ token: String) {
        self.token = token
    }
    
    private func requestWithoutToken<T: Encodable>(endpoint: String, method: HTTPMethod, parameters: T) -> AnyPublisher<Data, AFError> {
        let url = baseURL + endpoint
        
        return AF.request(url, method: method, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .publishData()
            .value()
            .eraseToAnyPublisher()
    }
    
    private func requestWithToken<T: Encodable>(endpoint: String, method: HTTPMethod, parameters: T) -> AnyPublisher<Data, AFError> {
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
                self.token = response.token
                return response.token
            }
            .eraseToAnyPublisher()
    }
    
    func login(user: UserAuthorizationModel) -> AnyPublisher<String, Error> {
        let loginRequest = LoginRequest(
            email: user.email,// + "@pmc-python.ru",
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
                self.token = response.token
                return response.token
            }
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        guard let token = token else {
            fatalError("Token is not set")
        }
        
        let url = baseURL + "logout"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        return AF.request(url, method: .post, headers: headers)
            .validate()
            .publishData()
            .tryMap { data in
                print("Logout successful")
                self.token = nil
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    //    func fetchUserProfile() -> AnyPublisher<UserProfile, AFError> {
    //        guard let token = token else {
    //            fatalError("Token is not set")
    //        }
    //
    //        let url = baseURL + "users/me"
    //        let headers: HTTPHeaders = [
    //            "Authorization": "Bearer \(token)"
    //        ]
    //        print("Sending fetch user profile request to \(url) with headers: \(headers)")
    //
    //        return AF.request(url, headers: headers)
    //            .validate()
    //            .publishDecodable(type: UserProfile.self)
    //            .value()
    //            .eraseToAnyPublisher()
    //    }
    
    func fetchUserProfile() -> AnyPublisher<UserProfile, AFError> {
        guard let token = token else {
            fatalError("Token is not set")
        }

        let url = baseURL + "users/me"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        print("Sending fetch user profile request to \(url) with headers: \(headers)")

        return AF.request(url, headers: headers)
            .validate()
            .publishDecodable(type: UserProfile.self)
            .value()
            .handleEvents(receiveSubscription: { _ in
                print("Subscription started for fetch user profile request.")
            }, receiveOutput: { userProfile in
                print("Received user profile: \(userProfile)")
            }, receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Fetch user profile request finished successfully.")
                case .failure(let error):
                    print("Fetch user profile request failed with error: \(error)")
                }
            }, receiveCancel: {
                print("Fetch user profile request was cancelled.")
            })
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
