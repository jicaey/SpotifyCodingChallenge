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
    
    let makeLabel: UILabel = {
        let label = UILabel()
        label.font = avenirNext
        label.textColor = .white
        label.text = "Make a..."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchLast()
        
        view.alpha = 0
        view.backgroundColor = .white
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
        titleLabel.font = avenirBoldLarge
        navigationItem.titleView = titleLabel
        
        // Remove navBar shadow
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func setupViews() {
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        swipeView.dataSource = self
        swipeView.delegate = self
        view.addSubview(swipeView)
        swipeView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        view.addSubview(resultsView)
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
    }
    
    func animateIn() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1
        }) { (success) in
            self.view.layoutIfNeeded()
            self.resultsView.resultsTextView.text = "people: \(self.store.results)"
        }
    }
    
    func submitButtonTouched() {
        if let name = resultsView.nameTextField.text, let city = resultsView.cityTextField.text {
            store.postPeopleData(name: name, city: city)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.resultsView.nameTextField.alpha = 0
            self.resultsView.cityTextField.alpha = 0
            self.resultsView.submitButton.setTitle("Post Successful", for: .normal)
        }, completion: { success in
            self.store.fetchLast()
        })
    }
    
//    func restartButtonTouched() {}
}

extension HomeViewController: PaperOnboardingDataSource, PaperOnboardingDelegate {
    func onboardingItemsCount() -> Int {
        return 8
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = avenirTitle
        let descriptionFont = avenirLarge
        
        let pageOne: OnboardingItemInfo = ("imageName", "GET request to /people", "", "", colorOne, .white, .white, titleFont!, descriptionFont!)
        let pageTwo: OnboardingItemInfo = ("imageName", "POST request to /people", "", "", colorTwo, .white, .white, titleFont!, descriptionFont!)
        let pageThree: OnboardingItemInfo = ("imageName", "GET request to retrieve the object created", "", "", colorThree, .white, .white, titleFont!, descriptionFont!)
        let pageFour: OnboardingItemInfo = ("imageName", "PUT request to change city to “Brooklyn”", "", "", colorFour, .white, .white, titleFont!, descriptionFont!)
        let pageFive: OnboardingItemInfo = ("imageName", "GET request to /people/1", "", "", colorFive, .white, .white, titleFont!, descriptionFont!)
        let pageSix: OnboardingItemInfo = ("imageName", "DELETE request to /people/1", "", "", colorSix, .white, .white, titleFont!, descriptionFont!)
        let pageSeven: OnboardingItemInfo = ("imageName", "GET request to /people", "", "", colorSeven, .white, .white, titleFont!, descriptionFont!)
        let pageEight: OnboardingItemInfo = ("imageName", "Thanks for considering me!", "", "", colorThree, .white, .white, titleFont!, descriptionFont!)
        
        return [pageOne, pageTwo, pageThree, pageFour, pageFive, pageSix, pageSeven, pageEight][index]
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {}
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        
        switch index {
        case 0:
            resultsView.resultsTextView.text = "people: \(store.results)"
            
        case 1:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.resultsTextView.text = ""
            })
            
        case 2:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.submitButton.alpha = 0
                self.resultsView.cityTextField.alpha = 0
                self.resultsView.nameTextField.alpha = 0
            })
            
        case 3:
            store.updateFirst()
            
        case 4:
            store.getFirst()
            
        case 5:
            store.deleteFirst()
            
        case 6:
            store.fetchPeopleData()
            
        case 7:
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
            resultsView.resultsTextView.text = "people: \(store.results)"
            
        case 1:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.cityTextField.alpha = 1
                self.resultsView.nameTextField.alpha = 1
                self.resultsView.submitButton.alpha = 1
            })
            
        case 2:
            resultsView.resultsTextView.text = "people: \(store.last)"
        case 3:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.resultsTextView.text = "updated: \(self.store.updated)"
            })
            
        case 4:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.resultsTextView.text = "first: \(self.store.first)"
            })
            
        case 5:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.resultsTextView.text = "delete attempt: \(self.store.deleted)"
            })
            
        case 6:
            UIView.animate(withDuration: 0.4, animations: {
                self.resultsView.resultsTextView.text = "people: \(self.store.results)"
            })
            
        case 7:
//            store.deleteAll()
            UIView.animate(withDuration: 0.6, animations: {
                self.resultsView.alpha = 0
                self.makeLabel.alpha = 0
            })

        default: break
        }
    }
}

















