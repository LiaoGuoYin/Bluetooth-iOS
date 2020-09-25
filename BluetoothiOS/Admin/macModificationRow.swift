//
//  macModificationRow.swift
//  BluetoothiOS
//
//  Created by LiaoGuoYin on 2020/9/25.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import SwiftUI

struct MACModificationRow: View {
    @State var modification: AdminMacManagerResponseData
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("学号: ") + Text(modification.studentNumber)
                    .font(.headline)
                Text("时间: ") + Text(modification.datetime)
                    .font(.subheadline)
                Text("New MAC: ") + Text(modification.mac)
                    .font(.subheadline)
            }
            Spacer()
            Text(modification.isPassed ? "已审核" : "待审核")
                .foregroundColor(modification.isPassed ? Color.blue : Color.gray.opacity(0.8))
        }
    }
}


struct MACModifyView_Previews: PreviewProvider {
    static var previews: some View {
        let demoData = """
        [
            {
              "_id": "5f6ccee0b682a3081109526e",
              "number": "1001",
              "type": "mac",
              "data": "4C:1A:3D:49:3E:6C",
              "status": 0,
              "datetime": 1600966368043
            },
            {
              "_id": "5f6ccf44b682a3081109526f",
              "number": "471920358",
              "type": "mac",
              "data": "4C:1A:3D:49:3E:6w",
              "status": 0,
              "datetime": 1600966468257
            },
            {
              "_id": "5f6d3efdb682a30811095270",
              "number": "0001",
              "type": "mac",
              "data": "AS:AS:CS:DS:S0:20",
              "status": 0,
              "datetime": 1600995069553
            }
          ]
""".data(using: .utf8)!
        
        let demoMACMadification = try! JSONDecoder().decode([AdminMacManagerResponseData].self, from: demoData)
        
        return MACModificationRow(modification: demoMACMadification.randomElement()!)
    }
}
