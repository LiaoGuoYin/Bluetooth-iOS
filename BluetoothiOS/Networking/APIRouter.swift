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
    
    case studentLogin(username: String, password: String)
    case studentRegist(studentRegistForm: StudentForm)
    case studentMACAppeal(username: String)
    case studentSignList(username: String)
    case studentSignAppeal(username: String, courseName: String)
    case studentModifyMac(username: String, newMac: String)
    
    case teacherLogin(username:String, password:String)
    case teacherRegist(form: StudentForm)
    case teacherGetCourse(username: String)
    case teacherGetStudentListByClassName(className: String)
    case teacherCreateCourse(teacherNumber: String, course: Course)
    case teacherDeleteCourse(teahcerNumber: String, courseName: String)
    case teacherGetStudentAppeal(teacherNumber: String)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .studentLogin, .studentRegist, .studentMACAppeal, .studentSignList, .studentSignAppeal, .studentModifyMac:
            return .post
        case .teacherRegist, .teacherLogin, .teacherGetCourse, .teacherGetStudentListByClassName, .teacherCreateCourse, .teacherDeleteCourse:
            return .post
        case .teacherGetStudentAppeal:
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
        case .studentSignAppeal:
            return "/lntusign/api/student/signappeal"
        case .studentMACAppeal:
            return "/lntusign/api/student/modifymac"
        case .studentSignList:
            return "/lntusign/api/student/getsignlist"
        case .studentModifyMac:
            return "/lntusign/api/student/modifymac"
            
        case .teacherLogin:
            return "/lntusign/api/login/teacher"
        case .teacherRegist:
            return "/lntusign/api/register/teacher"
        case .teacherGetCourse:
            return "/lntusign/api/teacher/getcourse"
        case .teacherGetStudentListByClassName:
            return "/lntusign/api/teacher/getstudents"
        case .teacherCreateCourse:
            return "/lntusign/api/teacher/createcourse"
        case .teacherDeleteCourse:
            return "/lntusign/api/teacher/deletecourse"
        case .teacherGetStudentAppeal:
            return "/lntusign/api/teacher/getstuappeal"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .studentLogin(let username, let password), .teacherLogin(let username, let password):
            return [K.APIParameterKey.username: username, K.APIParameterKey.password: password]
        case .studentRegist(let form):
            return [
                K.RegisterParameterKey.number: form.number,
                K.RegisterParameterKey.password: form.password,
                K.RegisterParameterKey.iClass: form.iClass,
                K.RegisterParameterKey.mac: form.mac,
                K.RegisterParameterKey.name: form.name
            ]
        case .studentMACAppeal(let username):
            return [K.RegisterParameterKey.number: username]
        case .studentSignList(let username):
            return [K.RegisterParameterKey.number: username]
        case .studentSignAppeal(let username, let courseName):
            return [
                K.RegisterParameterKey.number: username,
                K.RegisterParameterKey.courseName: courseName
            ]
        case .studentModifyMac(let username, let newMac):
            return [
                K.APIParameterKey.username: username,
                K.RegisterParameterKey.newMac: newMac
            ]
        case .teacherRegist(let form):
            return [
                K.RegisterParameterKey.number: form.number,
                K.RegisterParameterKey.password: form.password,
                K.RegisterParameterKey.name: form.name,
                K.RegisterParameterKey.phone: form.phone
            ]
        case .teacherGetCourse(let username):
            return [K.APIParameterKey.username: username]
        case .teacherGetStudentListByClassName(let className):
            return [K.TeacherParmeterKey.className: className]
        case .teacherCreateCourse(let teahcerNumber, let course):
            return [
                K.TeacherParmeterKey.courseName: course.name,
                K.TeacherParmeterKey.classroom: course.roomOf,
                K.RegisterParameterKey.iClass: course.classOf,
                K.RegisterParameterKey.number: teahcerNumber
            ]
        case .teacherDeleteCourse(let teacherNumber, let courseName):
            return [
                K.RegisterParameterKey.number: teacherNumber,
                K.TeacherParmeterKey.courseName: courseName
            ]
        case . teacherGetStudentAppeal(let teacherNumber):
            return [
                K.APIParameterKey.username: teacherNumber
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
