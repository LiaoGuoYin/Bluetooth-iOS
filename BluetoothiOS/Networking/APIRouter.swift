//
//  APIRouter.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/15.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Alamofire
import Foundation

enum APIRouter: URLRequestConvertible {
    
    case studentLogin(username:String, password:String)
    case studentRegist(studentRegistForm: StudentForm)
    case teacherRegist(form: StudentForm)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .studentLogin:
            return .post
        case .studentRegist:
            return .post
        case .teacherRegist:
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .studentLogin:
            return "/lntusign/api/login/student"
        case .studentRegist:
            return "/lntusign/api/register/student"
        case .teacherRegist:
            return "/lntusign/api/register/teacher"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .studentLogin(let username, let password):
            return [K.APIParameterKey.username: username, K.APIParameterKey.password: password]
        case .studentRegist(let form):
            return [
                K.StudentRegisterParameterKey.number: form.number,
                K.StudentRegisterParameterKey.password: form.password,
                K.StudentRegisterParameterKey.iClass: form.iClass,
                K.StudentRegisterParameterKey.mac: form.mac,
                K.StudentRegisterParameterKey.name: form.name
            ]
        case .teacherRegist(let form):
            return [
                K.StudentRegisterParameterKey.number: form.number,
                K.StudentRegisterParameterKey.password: form.password,
                K.StudentRegisterParameterKey.name: form.name,
                K.StudentRegisterParameterKey.phone: form.phone
            ]
        }
    }
    
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
