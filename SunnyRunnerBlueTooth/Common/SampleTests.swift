//
//  SampleTests.swift
//  LNTUHelper
//
//  Created by LiaoGuoYin on 2020/3/22.
//  Copyright © 2020 LiaoGuoYin. All rights reserved.
//

import Foundation

var noticeSampleJson = """
{  "code": 200,
  "message": "LNTUHelper App 上线，小伙伴们欢呼雀跃吧",
  "data": [
    {
      "url": "http://jwzx.lntu.edu.cn/index/../info/1103/1333.htm",
      "detail": {
        "title": "辽宁工程技术大学“课程思政”教学改革工作通知",
        "date": "2019-11-11",
        "content": "为贯彻落实全国高校思想政治工作会议精神，发挥课堂教学在育人中的主渠道、主阵地作用，全方位实现课程的思想教育和价值引领功能，根据省教育厅文件精神和《辽宁工程技术大学“课程思政”教育教学改革工作方案》要求，制定本方案。",
        "appendix": [
          {
            "url": "附件1：辽宁工程技术大学“课程思政”教学设计指南.docx",
            "name": "http://jwzx.lntu.edu.cn//system/_content/download.jsp?urltype=news.DownloadAttachUrl&owner=1522094051&wbfileid=3831934"
          },
          {
            "url": "附件2：学期末课程思政示范课情况汇总表.xlsx",
            "name": "http://jwzx.lntu.edu.cn//system/_content/download.jsp?urltype=news.DownloadAttachUrl&owner=1522094051&wbfileid=3831935"
          }
        ]
      }
    }
  ]
}
""".data(using: .utf8)!

var classTableSampleJson = """
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "code": "H101730023056.01",
      "name": "测试课",
      "teacher": "杨彤骥",
      "credit": "3.5",
      "schedule": [
        {
          "code": "H101730023056.01",
          "room": [
            "静远楼239"
          ],
          "weeks": "2-11",
          "weekday": 5,
          "index": 1
        },
        {
          "code": "H101730023056.01",
          "room": [
            "静远楼239"
          ],
          "weeks": "2-11",
          "weekday": 2,
          "index": 1
        }
      ]
    },
    {
      "code": "H101775104004.01",
      "name": "测试专业课",
      "teacher": "温廷新",
      "credit": "4",
      "schedule": [{
        "code": "H101730023056.01",
        "room": [
          "静远楼239"
        ],
        "weeks": "1-11",
        "weekday": 2,
        "index": 1
      }]
    }
  ]
}
""".data(using: .utf8)!

var GPASampleJson = """
{
  "code": 200,
  "message": "success",
  "data": {
    "GPA": "0",
    "counts": "52",
    "credits": "121.5",
    "effectiveTime": "2020-03-22 10:58",
    "GPAs": [
      {
        "yearSection": "2017-2018",
        "semester": "秋",
        "count": "13",
        "credit": "26.5",
        "semesterGPA": "0"
      },
      {
        "yearSection": "2018-2019",
        "semester": "秋",
        "count": "10",
        "credit": "26.5",
        "semesterGPA": "0"
      },
      {
        "yearSection": "2017-2018",
        "semester": "春",
        "count": "11",
        "credit": "24.5",
        "semesterGPA": "0"
      },
      {
        "yearSection": "2019-2020",
        "semester": "秋",
        "count": "10",
        "credit": "19.5",
        "semesterGPA": "0"
      },
      {
        "yearSection": "2018-2019",
        "semester": "春",
        "count": "8",
        "credit": "24.5",
        "semesterGPA": "0"
      }
    ]
  }
}
""".data(using: .utf8)!

var scoreSampleJson = """
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "code": "H101730021040.1",
      "semester": "2019-2020 1",
      "name": "微机原理（双语）",
      "courseType": "专业必修",
      "grade": "98",
      "credit": "2.5",
      "gradeDetail": {
        "usual": "19",
        "interim": "100",
        "final": "98",
        "general": "98"
      }
    }
  ]
}
""".data(using: .utf8)!

var infoExampleJson = """
{
  "code": 200,
  "message": "success",
  "data": {
    "username": "1710030111",
    "name": "LiaoGuoYin",
    "photoURL": "http://202.199.224.119:8080/eams/showSelfAvatar.action?user.name=1710030111",
    "nickname": "abc",
    "gender": "男",
    "grade": "2017",
    "eduLength": "4",
    "project": "主修",
    "education": "本科",
    "studentType": "本科4年",
    "college": "滑水学院",
    "major": "摸鱼专业",
    "direction": null,
    "enrollDate": "2017-09-01",
    "graduateDate": "2021-07-01",
    "chiefCollege": "滑水学院",
    "studyType": null,
    "membership": "是",
    "isInSchool": "是",
    "withCampus": "辽宁工大葫芦岛校区",
    "withClass": "潜水班级",
    "recordEffectDate": "2017-09-01",
    "isOwnRecord": "是",
    "studentStatus": "在校",
    "isWorking": "否"
  }
}
""".data(using: .utf8)!

var decoder = JSONDecoder()
var noticeSample = try! decoder.decode(NoticeResponse.self, from: noticeSampleJson)
