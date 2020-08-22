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
        return "学号：\(self.id)，姓名： \(self.name)，班级：\(self.classOf)，MAC地址：\(self.mac)"
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
姓名,班级,学号,MAC,
欧珀,电信研181,471820336,4c1a3d493e6c,√
吴埃斯,电信研183,123456778,BCE143B46210,√
吴一帆,工商研183,123456789,7836CC44578C,
杨清雷,土木研183,234567890,3CA581792440,
张世晔,英语研183,345678901,D461DA37FC98,
霍泽生,数学研183,456789112,A4504689B81F,
吕英鑫,工管研183,123231132,9487E09F9B02,√
初殿宇,法学研183,234563457,A4933F817F83,
刘埃斯,工商研184,225039186,044BED769B5E,
方彦瑾,安全研183,345678922,9CE82B8128AC,
铁牛,电控研181,863487827,4404446AA450,√
袁超,安全研183,683268688,482CA03CDEB7,√
唐玉莲,工管研183,671256411,F4BF8008D846,√
周雪,财贸研183,67136728,047970E090B6,√
潘佳欣,法学研183,315263533,A4933F818390,√
皮克嗖,英语研185,527737383,B4F1DA9A361D,√
维沃,机械研182,352033185,488764443630,√
十一,电信研188,342708190,B87BC5C6303B,√
end\r
"""

/// 反序列化收到的字串
/// - Parameter receivedString: 从蓝牙外设收到的字符串
/// - Returns: 学生名单
func parseReceivedStudents(receivedString: String) -> [Student] {
    var parsedStudents: Array<Student> = []
    if !(receivedString.hasPrefix("姓名,班级,学号") && receivedString.hasSuffix("end\r")) {
        print("收到的数据不符合模版格式")
        return []
    }
    var receivedStudents = receivedString.split(separator: "\n")
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

var studentsDemo: Array<Student> = parseReceivedStudents(receivedString: testRecivedStudents)

func createDemoCourse(_ students: Array<Student>) -> Course {
    return Course()
}

var courseDemo = createDemoCourse(studentsDemo)
