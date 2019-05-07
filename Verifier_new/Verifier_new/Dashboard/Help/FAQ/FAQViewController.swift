//
//  FAQViewController.swift
//  Verifier_new
//
//  Created by Кирилл Ковыршин on 18/12/2018.
//  Copyright © 2018 Verifier. All rights reserved.
//

import UIKit

class FAQViewController: VerifierAppDefaultViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - OUTLETS
    @IBOutlet var faqView: FAQView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - PROPERTIES
    var isChildQuestion = false
    var selectedIndex: Int?
    var tableArray = [[String : Any]]()
    let faqQuestions = [["parentQue" : "Информация",
                                 "childQue":[
                                    ["queTitle":"Поменять язык",
                                     "queAnswer":"Для того, чтобы поменять язык в мобильном приложении, зайдите в Профиль > Редактировать > Язык > Выберите подходящий вам язык"],
                                    ["queTitle":"Как связаться со службой поддержки во время выполнения задания",
                                     "queAnswer":"Находясь в самом задании, нажмите на иконку чата в правом верхнем углу и опишите вашу ситуацию."]
                                ]],
                                       ["parentQue" : "Задания",
                                        "childQue":[
                                            ["queTitle":"Как найти задания в работе",
                                             "queAnswer":"Зайти в Мои задания > В работе"],
                                            ["queTitle":"Как открыть общий список доступных заданий",
                                             "queAnswer":"Нужно зайти в меню \"Все Задания\""],
                                            ["queTitle":"Нет доступных заданий",
                                             "queAnswer":"Одна из причин, почему вы не видите задания – это отсутствие заданий от заказчиков\n\n"+"Однако задания могут отсутствовать и по другим причинам. Что нужно делать:\n"+"- Зайдите в фильтры:\n"+"• В поле «По времени выполнения» – выберите фильтр «Все»\n"+"• В поле «По радиусу» - выберите максимальное значение «20 км»\n"+"• В поле «по содержанию» - выберите значение «ALL»\n"+"Нажмите кнопку сохранить.\n"+"Если после выше перечисленных действий, доступные задания не появились, то обратитесь в службу поддержки. "],
                                            ["queTitle":"Не получается сделать фото",
                                             "queAnswer":"Зайдите в настройки телефона и разрешите доступ приложения Verifier к вашей камере. Если это не помогло, обратитесь в службу поддержки"],
                                            ["queTitle":"Не могу проложить маршрут по адресу задания",
                                             "queAnswer":"• Зайдите в настройки телефона и разрешите доступ приложения Verifier к вашей геолокации.\n\n"+"• Если у вас IOS, убедитесь в том, что на устройстве установлено приложение «Карты». Это приложение доступно только на IOS и путь к заданию открывается через него.\n"+"• Если у вас Android или другая ОС убедись, что установлено одно из приложений с картами.\n"+"• Если выше перечисленные советы не решили вашу проблему, обратитесь в службу поддержки"]
                                            
                                        ]],
                                       ["parentQue" : "Общее",
                                        "childQue":[
                                            ["queTitle":"Произшел сбой или иная проблема. В \"вопросах-ответах\" - нет подходящего ответа",
                                             "queAnswer":"Обратитесь в службу поддержки и опишите свою ситуацию"]
                                        ]],
                        ]
    let cellReuseIdentifier = "FAQСell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        faqView.localizationView()
        
        tableArray = faqQuestions
        
        
    }
    
    //MARK: - ACTIONS
    @IBAction func backButtonAction(_ sender: Any) {
        if isChildQuestion {
            isChildQuestion = false
            selectedIndex = nil
            tableArray = faqQuestions
            faqView.localizationView()
            tableView.reloadData()
        } else {
            self.navigationController?.hidesBottomBarWhenPushed = false
            self.navigationController?.popViewController(animated: false)
        }
        
    }
    
    
    //MARK UITableViewDELEGATE
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! FAQTableCell
        // set the text from the data model
        
    
        let dict = tableArray[indexPath.row]
        if isChildQuestion && selectedIndex != nil {
           
            cell.faqLabel?.text = dict["queTitle"] as? String
        } else {

            cell.faqLabel?.text = dict["parentQue"] as? String
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if !isChildQuestion && selectedIndex == nil {
            let dict = tableArray[indexPath.row]
            faqView.screenTitle.text = dict["parentQue"] as? String
            
            selectedIndex = indexPath.row
            isChildQuestion = true
            
            if let childQue =  faqQuestions[indexPath.row]["childQue"] as? [[String: Any]]  {
                tableArray = childQue
                print(tableArray)
                tableView.reloadData()
            }
        } else {
            let dict = tableArray[indexPath.row]
            
            print("GO to answer \(String(describing: faqView.screenTitle.text)) - QUEST \(String(describing: dict["queTitle"])) ANSWER \(String(describing: dict["queAnswer"]))")
            
            let storyboard = InternalHelper.StoryboardType.dashboard.getStoryboard()
            let indentifier = ViewControllers.faqAnswerVC.rawValue

            if let faqAnswerVC = storyboard.instantiateViewController(withIdentifier: indentifier) as? FAQShowAnswerViewController {
                faqAnswerVC.screenTitle = faqView.screenTitle.text
                faqAnswerVC.questionLabel = dict["queTitle"] as? String
                faqAnswerVC.answerLabel = dict["queAnswer"] as? String
                
                self.navigationController?.pushViewController(faqAnswerVC, animated: true)

            }
            
            
        }
        
        
        
        
    }
}

class FAQTableCell: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var faqLabel: UILabel!
    
    
}
