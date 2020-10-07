//
//  Student.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/28.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

struct Student {
    var number: Int
    var name: String
    var classOf: String
    var mac: String
    var status: String = Status.absent.rawValue
    
    var description: String {
        return "\(name),\(classOf),\(number),\(mac),\r"
    }
}

/// 蓝牙回传的用户状态：到场，旷课
enum Status: String {
    case present = "到场"
    case absent = "旷课"
}

extension Student: Hashable {
    init() {
        self.init(number: -1, name: "测试用户", classOf: "信管17-2", mac: "3CA581792440")
    }
    
    static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs.number == rhs.number
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
    }
}

extension Student: Codable {
    
    enum CodingKeys: String, CodingKey {
        case number
        case name
        case classOf = "iClass"
        case mac
        case status
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(number, forKey: .number)
        try container.encode(name, forKey: .name)
        try container.encode(classOf, forKey: .classOf)
        try container.encode(mac, forKey: .mac)
        try container.encode((status == Status.present.rawValue) ? "1": "0", forKey: .status)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let number = try container.decode(Int.self, forKey: .number)
        let name = try container.decode(String.self, forKey: .name)
        let classOf = try container.decode(String.self, forKey: .classOf)
        let mac = try container.decode(String.self, forKey: .mac)
        let status = try container.decode(String.self, forKey: .status)
        
        self.init(number: number, name: name, classOf: classOf, mac: mac, status: status)
    }
}

/// 反序列化收到的字串
/// - Parameter receivedString: 从蓝牙外设收到的字符串
/// - Returns: 学生名单
func deSerializingReceivedStudentsStringToArray(receivedString: String) -> Array<Student> {
    var parsedStudents: Array<Student> = []
    if !(receivedString.contains("MAC") && receivedString.contains("end")) {
        print("收到的数据不符合模版格式")
        return []
    }
    var receivedStudents = receivedString.split(separator: "\r\n")
    guard receivedStudents.count >= 2 else {
        return []
    }
    receivedStudents.removeFirst()// 姓名,班级,学号
    receivedStudents.removeLast()// end
    for each in receivedStudents {
        let items = each.split(separator: ",")
        guard items.count >= 3 else {
            continue
        }
        var newStudent = Student(number: Int(items[2]) ?? 0, name: String(items[0]), classOf: String(items[1]), mac: String(items[3]))
        if items.count == 5 {
            newStudent.status = Status.present.rawValue
        }
        parsedStudents.append(newStudent)
    }
    return parsedStudents
}

/// 序列化学生指定课程的学生列表，准备发送给蓝牙，打卡名单
/// - Parameter selection: 打卡班级
/// - Returns: 学生名单
func serializeStudentsToStringForSending(students: Array<LoginResponseData>) -> String {
    var resultString: String = "姓名,班级,学号,MAC,\r\n"
    for student in students {
        resultString.addString(student.description)
    }
    resultString.addString("end\r\n")
    return resultString
}
