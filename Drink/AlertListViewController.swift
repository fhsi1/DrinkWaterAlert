//
//  AlertListViewController.swift
//  Drink
//
//  Created by Yujean Cho on 2022/04/08.
//

import UIKit
import UserNotifications

class AlertListViewController: UITableViewController {
    
    // Alarm 을 추가하기전에는 빈 배열
    var alerts: [Alert] = []
    
    // Notification 변수 선언
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        let nibName = UINib(nibName: "AlertListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlertListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // UserDefault 에 저장된 값대로 alerts 가 반영된다.
        self.alerts = alertList()
    }
    
    @IBAction func addAlertButtonAction(_ sender: UIBarButtonItem ) {
        guard let addAlertViewController = storyboard?.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        // addAlertViewController present style fullscreen 적용
        addAlertViewController.modalPresentationStyle = .fullScreen
        
        // 생성된 alram 을 list 에 표현되도록 closure 구현
        addAlertViewController.pickedDate = { [weak self] date in
            guard let self = self else { return }
            
            var alertList = self.alertList() // UserDefault 에서 가져온 List
            let newAlert = Alert(date: date, isOn: true) // 처음 추가되었을 때 switch 는 true
            
            alertList.append(newAlert)
            alertList.sort { $0.date < $1.date } // 시간이 이른 순서대로 정렬
            
            self.alerts = alertList // 새로운 alert 를 append 하고 sort 한 새로운 alertList 를 다시 저장한다.
            
            // UserDefault 도 다시 저장
            // 임의의 객체이기 때문에 인코딩 디코딩이 필요하고, 이번에는 인코딩이 필요하다.
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            
            // noti 를 추가해주는 함수 추가
            // 새로 만들어진 alert 이 center 에도 저장된다.
            self.userNotificationCenter.addNotificationRequest(by: newAlert)
            
            self.tableView.reloadData()
        }
        
        self.present(addAlertViewController, animated: true, completion: nil)
    }
    
    // UserDefault 를 사용하여 알람 저장
    func alertList() -> [Alert] {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return [] }
        return alerts
    }
}

// UITableView Datasource, Delegate
extension AlertListViewController {
    // TableView 의 row 개수는 alerts 의 개수와 동일
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    // Section 을 나눠서 header 표현
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: // 첫 번째 section 이라면 title 을 보여준다.
            return "💧 물 마실 시간"
        default: // 그 외 section
            return nil
        }
    }
    
    // header 너비 조정으로 title 과의 간격 조정
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    // cell 을 선언해주고, cell 내부의 component 들의 data 를 전달해준다.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListCell", for: indexPath) as? AlertListCell else { return UITableViewCell() }
        
        // 처음 alram 이 설정되었을 때는 on 으로 설정
        cell.alertSwitch.isOn = alerts[indexPath.row].isOn
        
        // timeLabel 에 표시할 내용
        cell.timeLabel.text = alerts[indexPath.row].time
        
        // 오전·오후
        cell.meridiemLabel.text = alerts[indexPath.row].meridiem
        
        // cell 이 자신의 index 값을 알 수 있는 방법 - tag 값 부여
        cell.alertSwitch.tag = indexPath.row
        
        return cell
    }
    
    // cell 의 높이 설정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 추후에 알람을 삭제하거나 cell 을 삭제할 때는 알람 전체가 삭제 될 수 있도록 Action 추가 - Delegate 추가
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // 바꿀 수 있다.
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // alarm 삭제
            // userNotificationCenter 가 가지고 있는 request 중에서
            // 남아있는 notification 요청 중, 특정한 id 에 해당하는 request 만 삭제하겠다.
            // 아직 보내지 않고 pending 되어있는 request 를 삭제할 것이기 때문에 removePendingNotificationRequests 로 작성
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[indexPath.row].id])
            
            // notification 삭제 구현
            self.alerts.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            tableView.reloadData()
        default:
            break
        }
    }
}
