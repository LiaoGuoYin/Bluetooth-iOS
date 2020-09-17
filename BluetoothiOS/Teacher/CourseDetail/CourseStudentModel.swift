//
//  Student.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/28.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

struct Student: CustomStringConvertible {
    var number: Int
    var name: String
    var classOf: String
    var mac: String
    var status: Status = .absent
    
    var description: String {
        /*
         姓名,班级,学号,MAC,\r
         丁一,111,1,BCE143B46210,√\r
         吴一帆,183,2,7836CC44578C,\r
         */
        return "\(name),\(classOf),\(number),\(mac),\r"
    }
    
    /// 蓝牙回传的用户状态：到场，旷课
    enum Status: String {
        case present = "到场"
        case absent = "旷课"
    }
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

var testRecivedStudents = """
姓名,班级,学号,MAC,\r
丁一,111,1,BCE143B46210,√\r
吴一帆,183,2,7836CC44578C,\r
杨清雷,183,3,3CA581792440,\r
end\r
"""

/// 反序列化收到的字串
/// - Parameter receivedString: 从蓝牙外设收到的字符串
/// - Returns: 学生名单
func deSerializingReceivedStudentsStringToArray(receivedString: String) -> [Student] {
    var parsedStudents: Array<Student> = []
    if !(receivedString.hasPrefix("姓名,班级,学号") && receivedString.contains("end")) {
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
            newStudent.status = .present
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

var studentsDemo: Array<Student> = deSerializingReceivedStudentsStringToArray(receivedString: testRecivedStudents)

func createDemoCourse(_ students: Array<Student>) -> Course {
    return Course()
}

var courseDemo = createDemoCourse(studentsDemo)
