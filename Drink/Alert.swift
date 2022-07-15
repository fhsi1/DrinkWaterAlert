//
//  Alert.swift
//  Drink
//
//  Created by Yujean Cho on 2022/04/08.
//

import Foundation

// 리스트에 표시되는 Alert 객체
// why? Codable
struct Alert: Codable {
    var id: String = UUID().uuidString
    let date: Date // 시간
    var isOn: Bool // 해당 알람이 켜져있는지 여부
    
    // MARK: Date 값을 받으면 바로 라벨에 시간값과 오전·오후 값을 보여줄 수 있도록 한다.
    
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        return timeFormatter.string(from: date)
    }
    
    var meridiem: String {
        let meridiemFormatter = DateFormatter()
        meridiemFormatter.dateFormat = "a"
        meridiemFormatter.locale = Locale(identifier: "ko") // korea
        return meridiemFormatter.string(from: date)
    }
}
