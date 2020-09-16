//
//  APIClient.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/15.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, AFError>)->Void) -> DataRequest {
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
                completion(response.result)
            }
    }
    
    static func studentLogin(username: String, password: String, completion: @escaping (Result<LoginResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.studentLogin(username: username, password: password), completion: completion)
    }
    
    static func studentRegist(form: StudentForm, completion: @escaping (Result<RegistResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.studentRegist(studentRegistForm: form), completion: completion)
    }
    
}
