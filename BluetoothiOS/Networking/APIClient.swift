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
    
    static func studentRegist(form: StudentForm, completion: @escaping (Result<MessageResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.studentRegist(studentRegistForm: form), completion: completion)
    }
    
    static func Login(username: String, password: String, userType: UserType, completion: @escaping (Result<LoginResponse, AFError>) -> Void) {
        if userType == .student {
            performRequest(route: APIRouter.studentLogin(username: username, password: password), completion: completion)
        } else if userType == .teacher {
            performRequest(route: APIRouter.teacherLogin(username: username, password: password), completion: completion)
        } else {
            
        }
    }
    
    static func adminLogin(username: String, password: String, userType: UserType, completion: @escaping (Result<AdminLoginResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.adminLogin(username: username, password: password), completion: completion)
    }
    
    static func studentSignList(username: String, completion: @escaping (Result<SignListResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.studentSignList(username: username), completion: completion)
    }
    
    static func studentSignAppeal(sign: SignListResponseData, teacherName: String, completion: @escaping (Result<MessageResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.studentSignAppeal(sign: sign, teacherName: teacherName), completion: completion)
    }
    
    static func studentModifyMac(username: String, newMac: String, completion: @escaping (Result<MessageResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.studentModifyMac(username: username, newMac: newMac), completion: completion)
    }
    
    static func teacherRegist(form: StudentForm, completion: @escaping (Result<MessageResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.teacherRegist(form: form), completion: completion)
    }
    
    static func teacherGetCourse(username: String, completion: @escaping (Result<CourseResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.teacherGetCourse(username: username), completion: completion)
    }
    
    static func teacherGetStudentListByClassName(className: String, completion: @escaping (Result<ClassStudentResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.teacherGetStudentListByClassName(className: className), completion: completion)
    }
    
    static func teacherCreateCourse(_ teacherNumber: String, _ course: Course, completion: @escaping (Result<LoginResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.teacherCreateCourse(teacherNumber: teacherNumber, course: course), completion: completion)
    }
    
    static func teacherDeleteCourse(_ teahcerNumber: String, _ courseName: String, completion: @escaping (Result<MessageResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.teacherDeleteCourse(teahcerNumber: teahcerNumber, courseName: courseName), completion: completion)
    }
    
    static func teacherGetClass(completion: @escaping (Result<ClassListResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.teacherGetClass, completion: completion)
    }
    
    static func teacherUploadCourse(_ record: CourseRecord, completion: @escaping (Result<MessageResponse, AFError>) -> Void) {
        let url = try! K.ProductionServer.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent("/lntusign/api/teacher/updatesigninfo"))
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.httpBody = try! JSONEncoder().encode(record)
        
        AF.request(urlRequest).responseDecodable (decoder: JSONDecoder()){ (response: DataResponse<MessageResponse, AFError>) in
            completion(response.result)
        }
    }

    static func teacherGetStudentSignList(teacherNumber: String, completion: @escaping (Result<SignListResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.teacherGetStudentSignList(teacherNumber: teacherNumber), completion: completion)
    }
    
    static func teacherGetStudentSignAppeal(teacherNumber: String, completion: @escaping (Result<AdminSignAppealListResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.teacherGetStudentAppeal(teacherNumber: teacherNumber), completion: completion)
    }
    
    static func processMacModify(processMac: MacModificationRequestData, completion: @escaping (Result<MessageResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.teacherProcessMacModify(processMac: processMac), completion: completion)
    }
    
    static func processSignAppeal(signId: String, completion: @escaping (Result<MessageResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.teacherProcessSignAppeal(signId: signId), completion: completion)
    }
    
    static func adminGetMacmodification(completion: @escaping (Result<AdminMacManagerResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.adminGetMacmodification, completion: completion)
    }
    
    static func adminGetSignAppealList(completion: @escaping (Result<AdminSignAppealListResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.adminGetSignAppealList, completion: completion)
    }
    
    static func adminGetSignList(completion: @escaping (Result<SignListResponse, AFError>) -> Void) {
        performRequest(route: APIRouter.adminGetSignList, completion: completion)
    }
    
}
