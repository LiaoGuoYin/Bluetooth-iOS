//
//  APIService.swift
//  LNTUHelper
//
//  Created by LiaoGuoYin on 2020/3/18.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    static let API_ROOT = "https://api.liaoguoyin.com"

    lazy private var clientSession: Session = {
        let l = (UserDefaults.standard.object(forKey: "AppleLanguages") as! Array<String>)[0]
        var defaultHeaders = URLSessionConfiguration.default.headers
        defaultHeaders["User-Agent"] = (defaultHeaders["User-Agent"] ?? "") + "LNTUHelper v1.0 beta"
        defaultHeaders["Accept-Language"] = "\(l),zh;q=1.0, gzip;q=0.8, deflate;q=0.6"
        let configuration = URLSessionConfiguration.af.default
        configuration.headers = defaultHeaders
        let clientSession = Session(configuration: configuration)
        return clientSession
    }()

    func getNotice(completion: @escaping (NoticeResponse) -> ()) {
        self.clientSession.request(APIService.API_ROOT + "/notice")
            .cURLDescription() { description in
                print(description)
            }
            .responseDecodable(of: NoticeResponse.self) { (response) in
                debugPrint(response)
                switch response.result {
                case let .success(data):
                    completion(data)
                case let .failure(error):
                    print(error)
                }
        }
    }
}

