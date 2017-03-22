//
//  HomeViewController.swift
//  SpotifyCodingChallenge
//
//  Created by Michael Young on 3/19/17.
//  Copyright © 2017 Michael Young. All rights reserved.
//

import UIKit
import SnapKit
import TRON
import SwiftyJSON
import PaperOnboarding

class HomeViewController: UIViewController {
    let store = DataStore.sharedInstance
    let swipeView = SwipeView()
    let resultsView = ResultsView()
    let peopleTableView = UITableView()
    
    let makeLabel: UILabel = {
        let label = UILabel()
        label.font = avenirTitle
        label.textColor = .white
        label.text = "Make a..."
        return label
    }()
    
//    let restartButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("RESTART?", for: .normal)
//        button.titleLabel?.font = avenirGiant
//        button.titleLabel?.textColor = colorThree
//        button.alpha = 0
//        button.layer.cornerRadius = 5
//        button.layer.borderWidth = 0.5
//        button.layer.borderColor = UIColor.white.cgColor
//        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
//        button.addTarget(nil, action: #selector(restartButtonTouched), for: .touchUpInside)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateIn()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .clear
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "Spotify Coding Challenge"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = avenirGiant
        navigationItem.titleView = titleLabel
        
        // Removes navBar shadow
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func setupViews() {
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        view.alpha = 0
        view.backgroundColor = .white
        
        swipeView.dataSource = self
        swipeView.delegate = self
        view.addSubview(swipeView)
        swipeView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        view.addSubview(resultsView)
        resultsView.cityTextField.delegate = self
        resultsView.nameTextField.delegate = self
        resultsView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(navigationBarHeight! + statusBarHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.45)
        }
        
        view.addSubview(makeLabel)
        makeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(0.4)
            make.top.equalTo(resultsView.snp.bottom).inset(10)
        }
        
//        view.addSubview(restartButton)
//        restartButton.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.5)
//        }
    }
    
    func animateIn() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1
        }) { success in
            self.view.layoutIfNeeded()
            self.resultsView.resultsTextView.text = "\(self.store.people)"
        }
    }
    
    func postButtonTouched() {
        guard let name = resultsView.nameTextField.text else {
            return
        }
        
        guard let city = resultsView.cityTextField.text else {
            return
        }
        
        if name != "" && city != "" {
            store.postPeopleData(name: name, city: city)
            resultsView.resultsTextView.text = ""
            UIView.animate(withDuration: 0.3, animations: {
                self.resultsView.nameTextField.alpha = 0
                self.resultsView.cityTextField.alpha = 0
                self.resultsView.postButton.setTitle("Post Successful", for: .normal)
            }, completion: { success in
                self.resultsView.resultsTextView.text = self.store.statusString
            })
            
        } else {
            resultsView.resultsTextView.text = "Missing Some Data..."
            resultsView.postButton.setTitle("Try Again?", for: .normal)
        }
    }
    
    func setupTableView() {
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        peopleTableView.register(PersonCell.self, forCellReuseIdentifier: personCellID)
        
        peopleTableView.separatorStyle = .none
        peopleTableView.backgroundColor = .clear
        
        view.addSubview(peopleTableView)
        peopleTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.resultsView.nameCityLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.resultsView.resultsTextView)
        }
    }
    
//    func restartButtonTouched() {
//        self.view.setNeedsDisplay()
//    }
}

extension HomeViewController: PaperOnboardingDataSource, PaperOnboardingDelegate {
    func onboardingItemsCount() -> Int {
        return 8
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let pageOne = createOnboardingPage(title: "GET request to /people",
                                           description: "Responds with the full database table named 'people'.",
                                           color: colorOne)
        
        let pageTwo = createOnboardingPage(title: "POST request to /people",
                                           description: "Accepts a application/json Content-Type.",
                                           color: colorTwo)
        
        let pageThree = createOnboardingPage(title: "GET request to retrieve the object created",
                                             description: "I passed the ID from the previous step in a Get request.",
                                             color: colorThree)
        
        let pageFour = createOnboardingPage(title: "PUT request to change city to “Brooklyn”",
                                            description: "Tap an entry to change the city to Brooklyn",
                                            color: colorFour)
        
        let pageFive = createOnboardingPage(title: "GET request to /people/1",
                                            description: "Queries the database for userID: ”1”. Throws an error if user isn't found.",
                                            color: colorFive)
        
        let pageSix = createOnboardingPage(title: "DELETE request to /people/1",
                                           description: "Attempting to delete the entry in the database with ”1” as the userID.",
                                           color: colorSix)
        
        let pageSeven = createOnboardingPage(title: "GET request to /people",
                                             description: "Fetches full contects of database table",
                                             color: colorSeven)
        
        let pageEight = createOnboardingPage(title: "Thanks for considering me!",
                                             description: "",
                                             color: colorThree)
        
        return [pageOne, pageTwo, pageThree, pageFour, pageFive, pageSix, pageSeven, pageEight][index]
    }
    
    func createOnboardingPage(title: String, description: String, color: UIColor) -> OnboardingItemInfo {
        let page: OnboardingItemInfo = ("imageName", title, description, "", color, .white, .white, avenirTitle!, avenirLarge!)
        return page
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {}
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        switch index {
        case 0:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.postButton.alpha = 0
                self.resultsView.cityTextField.alpha = 0
                self.resultsView.nameTextField.alpha = 0
            })
            
        case 1:
            resultsView.cityTextField.text = ""
            resultsView.nameTextField.text = ""
            
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.resultsTextView.text = ""
            })
            
        case 2:
            resultsView.resultsTextView.text = ""
            
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.postButton.alpha = 0
                self.resultsView.cityTextField.alpha = 0
                self.resultsView.nameTextField.alpha = 0
                self.resultsView.nameCityLabel.alpha = 0
            })
            
            UIView.animate(withDuration: 0.5, animations: {
                self.peopleTableView.removeFromSuperview()
                self.resultsView.nameCityLabel.alpha = 0
            })
            
        case 3:
            resultsView.resultsTextView.text = ""
            self.store.getPeople()
            
        case 4:
            resultsView.resultsTextView.text = ""
            store.getFirst()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.peopleTableView.removeFromSuperview()
                self.resultsView.nameCityLabel.alpha = 0
            })
            
        case 5:
            resultsView.resultsTextView.text = ""
            store.deleteFirst()
            
        case 6:
            resultsView.resultsTextView.text = ""
            store.getPeople()
            
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.alpha = 1
//                self.restartButton.alpha = 0
            })
            
        case 7:
            resultsView.resultsTextView.text = ""
            
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.alpha = 0
                self.makeLabel.alpha = 0
            })
        default: break
        }
    }
  
    func onboardingDidTransitonToIndex(_ index: Int) {
        switch index {
        case 0:
            resultsView.resultsTextView.text = store.people
            
        case 1:
            UIView.animate(withDuration: 0.3, animations: {
                self.resultsView.cityTextField.alpha = 1
                self.resultsView.nameTextField.alpha = 1
                self.resultsView.postButton.alpha = 1
            })
            
        case 2:
            resultsView.resultsTextView.text = store.newPerson
            if store.newPerson == "" {
                resultsView.resultsTextView.text = "No new data posted"
            }
            
        case 3:
            self.setupTableView()
            
            UIView.animate(withDuration: 0.7, animations: {
                self.resultsView.nameCityLabel.alpha = 1
            })
            
        case 4:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.resultsTextView.text = "/people/1 GET attempt: \(self.store.first)"
            })
            
        case 5:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.resultsTextView.text = "/people/1 DELETE attempt: \(self.store.deleted)"
            })
            
        case 6:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.resultsTextView.text = self.store.people
                
            })
            
        case 7:
            UIView.animate(withDuration: 0.6, animations: {
                self.resultsView.alpha = 0
                self.makeLabel.alpha = 0
//                self.restartButton.alpha = 1
                
            })
        default: break
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.peopleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: personCellID, for: indexPath) as! PersonCell

        // TODO: Safely unwrap
        let person = store.peopleData[indexPath.row]
        cell.nameLabel.text = "\(person.name!)    •"
        cell.cityLabel.text = "\(person.favoriteCity!)"
        
        return cell
    }
    
    // TODO: Safely unwrap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = store.peopleData[indexPath.row]
        store.updateFavoriteCity(name: person.name!, city: person.favoriteCity!, id: person.id!)
        store.getPeople()
        
        self.view.setNeedsDisplay()
        self.setupTableView()
        tableView.reloadData()
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        postButtonTouched()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

















