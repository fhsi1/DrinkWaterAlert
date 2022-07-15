//
//  AddAlertViewController.swift
//  Drink
//
//  Created by Yujean Cho on 2022/04/11.
//

import UIKit

class AddAlertViewController: UIViewController {
    
    // 설정한 시간 값이 부모 view 에 전달이 될 수 있도록 한다. : closure 사용
    var pickedDate: ((_ date: Date) -> Void)?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        pickedDate?(datePicker.date) // datePicker 의 설정된 date 를 전달해준다.
        self.dismiss(animated: true, completion: nil)
    }
}
