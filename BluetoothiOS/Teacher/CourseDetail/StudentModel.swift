//
//  Student.swift
//  BluetoothPunchCard
//
//  Created by LiaoGuoYin on 2020/6/28.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

struct Student: CustomStringConvertible {
    var id: Int
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
        return "\(name),\(classOf),\(id),\(mac),\r"
    }
    
    /// 蓝牙回传的用户状态：到场，旷课
    enum Status: String {
        case present = "到场"
        case absent = "旷课"
    }
}

extension Student: Hashable {
    init() {
        self.init(id: -1, name: "测试用户", classOf: "信管17-2", mac: "3CA581792440")
    }
    
    static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

var testRecivedStudents = """
姓名,班级,学号,MAC,\r
丁一,111,1,BCE143B46210,√\r
吴一帆,183,2,7836CC44578C,\r
杨清雷,183,3,3CA581792440,\r
张世晔,183,4,D461DA37FC98,\r
霍泽生,183,5,A4504689B81F,\r
吕英鑫,183,6,9487E09F9B02,\r
初殿宇,183,7,A4933F817F83,\r
方彦瑾,183,8,9CE82B8128AC,\r
铁牛,181,9,4404446AA450,√\r
袁超,183,10,482CA03CDEB7,\r
唐玉莲,183,11,F4BF8008D846,\r
周雪,183,12,047970E090B6,\r
潘佳欣,183,13,A4933F818390,\r
尹亭月,183,14,2CA9F00BE204,\r
扈健民,183,15,9CE82B98AB50,\r
黄小龙,183,16,B894363C32D0,\r
郭勇,183,17,0479709D53C0,\r
冯凯浩,183,18,4CD1A1DA0104,\r
饶明钊,183,19,9487E0B6498A,\r
由广昊,183,134,af2536cdbbe66,\r
陈鑫,183,135,af2536cdbbe67,\r
王伟,183,136,af2536cdbbe68,\r
由广昊,183,137,af2536cdbbe69,\r
陈鑫,183,138,af2536cdbbe70,\r
王伟,183,139,af2536cdbbe71,\r
王伟,183,140,af2536cdbbe72,\r
由广昊,183,141,af2536cdbbe73,\r
陈鑫,183,142,af2536cdbbe74,\r
王伟,183,143,af2536cdbbe75,\r
由广昊,183,144,af2536cdbbe76,\r
陈鑫,183,145,af2536cdbbe77,\r
王伟,183,146,af2536cdbbe78,\r
王伟,183,147,af2536cdbbe79,\r
由广昊,183,148,af2536cdbbe80,\r
陈鑫,183,149,af2536cdbbe81,\r
王伟,183,150,af2536cdbbe82,\r
由广昊,183,151,af2536cdbbe83,\r
陈鑫,183,152,af2536cdbbe84,\r
王伟,183,153,af2536cdbbe85,\r
王伟,183,154,af2536cdbbe86,\r
由广昊,183,155,af2536cdbbe87,\r
陈鑫,183,156,af2536cdbbe88,\r
end\r
"""

/// 反序列化收到的字串
/// - Parameter receivedString: 从蓝牙外设收到的字符串
/// - Returns: 学生名单
func deSerializingReceivedStudentsStringToArray(receivedString: String) -> [Student] {
    var parsedStudents: Array<Student> = []
    if !(receivedString.hasPrefix("姓名,班级,学号") && receivedString.contains("end\r")) {
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
        var newStudent = Student(id: Int(items[2]) ?? 0, name: String(items[0]), classOf: String(items[1]), mac: String(items[3]))
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
func serializeStudentsToStringForSending(selection: Set<Course>) -> String {
    var resultString: String = "姓名,班级,学号,MAC,\r\n"
    for course in selection {
        for student in course.students {
            resultString.addString(student.description)
        }
    }
    resultString.addString("end\r")
    return resultString
}

var studentsDemo: Array<Student> = deSerializingReceivedStudentsStringToArray(receivedString: testRecivedStudents)

func createDemoCourse(_ students: Array<Student>) -> Course {
    return Course()
}

var courseDemo = createDemoCourse(studentsDemo)
