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
    case studentSignAppeal(sign: SignListResponseData, teacherName: String)
    case studentModifyMac(username: String, newMac: String)
    
    case teacherLogin(username:String, password:String)
    case teacherRegist(form: StudentForm)
    case teacherGetCourse(username: String)
    case teacherGetStudentListByClassName(className: String)
    case teacherCreateCourse(teacherNumber: String, course: Course)
    case teacherDeleteCourse(teahcerNumber: String, courseName: String)
    case teacherGetStudentAppeal(teacherNumber: String)
    case teacherGetClass
    case teacherProcessMacModify(processMac: MacModificationRequestData)
    case teacherProcessSignAppeal(signId: String)
    case teacherGetStudentSignList(teacherNumber: String)
    
    case adminLogin(username: String, password: String)
    case adminGetSignAppealList
    case adminGetMacmodification
    case adminGetSignList
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .studentLogin, .studentRegist, .studentMACAppeal, .studentSignList, .studentSignAppeal, .studentModifyMac:
            return .post
        case .teacherRegist, .teacherLogin, .teacherGetCourse, .teacherGetStudentListByClassName, .teacherCreateCourse, .teacherDeleteCourse, .teacherGetStudentAppeal, .teacherProcessMacModify, .teacherProcessSignAppeal, .teacherGetStudentSignList:
            return .post
        case .teacherGetClass:
            return .get
        case .adminLogin:
            return .post
        case .adminGetSignAppealList, .adminGetMacmodification, .adminGetSignList:
            return .get
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
        case .teacherGetClass:
            return "/lntusign/api/teacher/getclass"
        case .teacherProcessMacModify:
            return "/lntusign/api/teacher/processstumacmodify"
        case .teacherProcessSignAppeal:
            return "/lntusign/api/teacher/processstuappeal"
        case .teacherGetStudentSignList:
            return "/lntusign/api/teacher/getstusignlist"
            
        case .adminLogin:
            return "/lntusign/api/login/admin"
        case .adminGetSignAppealList:
            return "/lntusign/api/admin/getstuappealall"
        case .adminGetMacmodification:
            return "/lntusign/api/admin/getmacmodifyall"
        case .adminGetSignList:
            return "/lntusign/api/admin/getstusignlistall"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .studentLogin(let username, let password), .teacherLogin(let username, let password), .adminLogin(let username, let password):
            return [K.APIParameterKey.username: username, K.APIParameterKey.password: password]
        case .studentRegist(let form):
            return [
                K.StudentParameterKey.number: form.number,
                K.StudentParameterKey.password: form.password,
                K.StudentParameterKey.iClass: form.iClass,
                K.StudentParameterKey.mac: form.mac,
                K.StudentParameterKey.name: form.name
            ]
        case .studentMACAppeal(let username):
            return [K.StudentParameterKey.number: username]
        case .studentSignList(let username):
            return [K.StudentParameterKey.number: username]
        case .studentSignAppeal(let sign, let teacherName):
            return [
                K.TeacherParmeterKey.courseName: sign.courseName,
                K.TeacherParmeterKey.teacherName: teacherName,
                K.StudentParameterKey.name: sign.studentName ?? "",
                K.StudentParameterKey.number: sign.studentNumber ?? "",
                K.StudentParameterKey.iClass: sign.classOf ?? "",
                K.StudentParameterKey.mac: sign.mac ?? "",
                K.StudentParameterKey.date: sign.datetimeString
            ]
        case .studentModifyMac(let username, let newMac):
            return [
                K.APIParameterKey.username: username,
                K.StudentParameterKey.newMac: newMac
            ]
        case .teacherRegist(let form):
            return [
                K.StudentParameterKey.number: form.number,
                K.StudentParameterKey.password: form.password,
                K.StudentParameterKey.name: form.name,
                K.StudentParameterKey.phone: form.phone
            ]
        case .teacherGetCourse(let username):
            return [K.APIParameterKey.username: username]
        case .teacherGetStudentListByClassName(let className):
            return [K.TeacherParmeterKey.className: className]
        case .teacherCreateCourse(let teahcerNumber, let course):
            return [
                K.TeacherParmeterKey.courseName: course.name,
                K.TeacherParmeterKey.classroom: course.roomOf,
                K.StudentParameterKey.iClass: course.classList,
                K.StudentParameterKey.number: teahcerNumber
            ]
        case .teacherDeleteCourse(let teacherNumber, let courseName):
            return [
                K.StudentParameterKey.number: teacherNumber,
                K.TeacherParmeterKey.courseName: courseName
            ]
        case .teacherGetStudentAppeal(let teacherNumber):
            return [
                K.APIParameterKey.username: teacherNumber
            ]
        case .teacherProcessMacModify(let processMac):
            return [
                K.StudentParameterKey.id: processMac.id,
                K.StudentParameterKey.mac: processMac.mac,
                K.StudentParameterKey.number: processMac.studentNumber,
                K.StudentParameterKey.process: "1"
            ]
        case .teacherProcessSignAppeal(let signId):
            return [
                K.StudentParameterKey.id: signId,
                K.StudentParameterKey.process: "1"
            ]
        case .teacherGetStudentSignList(let username):
            return [
                K.APIParameterKey.username: username
            ]
        case .adminGetMacmodification, .adminGetSignAppealList, .adminGetSignList, .teacherGetClass:
            return nil
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
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}
