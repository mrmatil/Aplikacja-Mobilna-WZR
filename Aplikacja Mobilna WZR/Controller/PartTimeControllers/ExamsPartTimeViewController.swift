//
//  ExamsPartTimeViewController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 20/09/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class ExamsPartTimeViewController: UIViewController {

    //variables
    var groups = [String]()
    var lecturers = [String]()
    var subjects = [String]()
    
    var tempGroup = ""
    var group = ""
    var tempLecturer = ""
    var lecturer = ""
    var tempSubject = ""
    var subject = ""
    
    var groupsPV = UIPickerView()
    var lecturersPV = UIPickerView()
    var subjectsPV = UIPickerView()
    
    //IBOutlets
    @IBOutlet weak var groupsTextField: UITextField!
    @IBOutlet weak var lecturersTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    
    //IBActions
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "PTExam", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ExamsInfoViewController
        
        let temp = GetDataFromRealmExams.getFromRealm(FullTimeorPartTime: "N", group: group, lecturer: lecturer, subject: subject)
        for x in temp{
            vc.classroom.append(x.classroom!)
            vc.date.append(x.date!)
            vc.group.append(x.group!)
            vc.hour.append(x.hour!)
            vc.lecturer.append(x.lecturer!)
            vc.number.append(x.number!)
            vc.subject.append(x.subject!)
        }

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupsData()
        getSubjectsData()
        getLecturersData()
        // Do any additional setup after loading the view.
    }
    
    
    func getGroupsData(){
        let ud = UserDefaults()
        groups = [" "]
        groups.append(contentsOf: ud.array(forKey: "partTimeGroupsList") as! [String])
        enableGroupsPickerView()
    }
    
    func getLecturersData(){
        lecturers = [" "]
        lecturers.append(contentsOf: GetDataFromRealmExams.getLecturers())
        enableLecturersPickerView()
    }
    
    func getSubjectsData(){
        subjects = [" "]
        subjects.append(contentsOf: GetDataFromRealmExams.getSubjects())
        enableSubjectsPickerView()
    }
    
}

extension ExamsPartTimeViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func enableGroupsPickerView(){
        groupsPV.delegate=self
        groupsPV.dataSource=self
        groupsTextField.inputView = groupsPV
        groupsTextField.inputAccessoryView = enableToolbar()
    }
    
    func enableLecturersPickerView(){
        lecturersPV.delegate=self
        lecturersPV.dataSource=self
        lecturersTextField.inputView=lecturersPV
        lecturersTextField.inputAccessoryView=enableToolbar()
    }
    
    func enableSubjectsPickerView(){
        subjectsPV.delegate=self
        subjectsPV.dataSource=self
        subjectTextField.inputView=subjectsPV
        subjectTextField.inputAccessoryView=enableToolbar()
    }
    
    
    
    
    
    func enableToolbar() -> UIToolbar{
        let toolbar = UIToolbar()
        
        let okButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(okFunction))
        okButton.tintColor = UIColor(red: 24.0/255.0, green: 62.0/255.0, blue: 116.0/255.0, alpha: 1.0)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Powrót" , style: .plain, target: self, action: #selector(cancelFunction))
        cancelButton.tintColor = UIColor(red: 24.0/255.0, green: 62.0/255.0, blue: 116.0/255.0, alpha: 1.0)
        
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, spaceButton, okButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    @objc func okFunction(){
        if tempGroup != ""{
            group = tempGroup
            tempGroup = ""
            groupsTextField.text = group
        }
        if tempSubject != ""{
            subject = tempSubject
            tempSubject = ""
            subjectTextField.text = subject
        }
        if tempLecturer != ""{
            lecturer = tempLecturer
            tempLecturer = ""
            lecturersTextField.text = lecturer
        }
        view.endEditing(true)
        
    }
    
    @objc func cancelFunction(){
        view.endEditing(true)
    }
    
    
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case groupsPV:
            return groups.count
        case lecturersPV:
            return lecturers.count
        case subjectsPV:
            return subjects.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var text = ""
        switch pickerView {
        case groupsPV:
            text = groups[row]
        case lecturersPV:
            text = lecturers[row]
        case subjectsPV:
            text = subjects[row]
        default:
             text = ""
        }
        
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 24.0/255.0, green: 62.0/255.0, blue: 116.0/255.0, alpha: 1.0)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case groupsPV:
            tempGroup = groups[row]
        case lecturersPV:
            tempLecturer = lecturers[row]
        case subjectsPV:
            tempSubject = subjects[row]
        default:
            print("Domething went wrong")
        }
    }
    
    
}
