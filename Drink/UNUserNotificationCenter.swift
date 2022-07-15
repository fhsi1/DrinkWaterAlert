//
//  UNUserNotificationCenter.swift
//  Drink
//
//  Created by Yujean Cho on 2022/04/11.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    
    // alert 객체를 받아서 request 를 만들고 최종적으로 NotificationCenter 에 추가하는 함수
    func addNotificationRequest(by alert: Alert) {
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이에요 💦"
        content.body = "세계보건기구(WHO)가 권장하는 하루 물 섭취량은 1.5~2리터 입니다."
        content.sound = .default
        content.badge = 1
        
        // trigger 선언
        // DateComponents : 어떤 date 조건으로 할 것인지
        // repeats : 얼마나 반복할 것인지 - switch 가 켜져있는 동안 반복할 수 있도록 alert.isOn
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        
        // request 생성
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        
        // self - UNUserNotificationCenter
        self.add(request, withCompletionHandler: nil)
    }
}
