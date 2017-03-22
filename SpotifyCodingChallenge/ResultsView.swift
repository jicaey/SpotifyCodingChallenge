//
//  ResultsView.swift
//  SpotifyCodingChallenge
//
//  Created by Michael Young on 3/19/17.
//  Copyright © 2017 Michael Young. All rights reserved.
//

import UIKit
import SnapKit

class LeftPaddedTextField: UITextField, UITextFieldDelegate {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }

}

class ResultsView: UIView {
    let resultsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = colorTextfield
        textView.layer.cornerRadius = 5
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: -50, right: -10)
        textView.font = avenirBook
        textView.textColor = .white
        
        return textView
    }()
    
    let nameTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.backgroundColor = colorTwo.withAlphaComponent(0.5)
        textField.layer.cornerRadius = 5
        textField.alpha = 0
        textField.textAlignment = .left
        textField.font = avenirBoldLarge
        textField.textColor = .white
        textField.placeholder = "What is your name?"
        
        return textField
    }()
    
    let cityTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.backgroundColor = colorTwo.withAlphaComponent(0.5)
        textField.layer.cornerRadius = 5
        textField.alpha = 0
        textField.textAlignment = .left
        textField.font = avenirBoldLarge
        textField.textColor = .white
        textField.placeholder = "What is your Favorite City?"
        
        return textField
    }()
    
    let postButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = colorTwo
        button.layer.cornerRadius = 5
        button.alpha = 0
        button.titleLabel?.font = avenirBoldLarge
        button.addTarget(nil, action: #selector(HomeViewController.postButtonTouched), for: .touchUpInside)
        button.setTitle("Post", for: .normal)
        button.setTitle("Done", for: .selected)
        return button
    }()
    
    let nameCityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = avenirTitle
        label.text = "Name     Favorite City"
        label.textAlignment = .center
        label.alpha = 0
        label.backgroundColor = colorFour.withAlphaComponent(0.2)
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .clear
        
        addSubview(resultsTextView)
        resultsTextView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalToSuperview().multipliedBy(0.9)
        }
        
        addSubview(nameTextField)
        
        nameTextField.snp.makeConstraints { (make) in
            make.center.equalTo(resultsTextView)
            make.width.equalTo(resultsTextView).multipliedBy(0.85)
            make.height.equalTo(resultsTextView).multipliedBy(0.12)
        }
        
        addSubview(cityTextField)
        
        cityTextField.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.centerX.equalTo(resultsTextView)
            make.width.equalTo(resultsTextView).multipliedBy(0.85)
            make.height.equalTo(resultsTextView).multipliedBy(0.12)
        }
        
        addSubview(postButton)
        postButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityTextField.snp.bottom).offset(20)
            make.width.equalTo(cityTextField).multipliedBy(0.5)
        }
        
        addSubview(nameCityLabel)
        nameCityLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(resultsTextView)
            make.height.equalTo(resultsTextView).multipliedBy(0.1)
        }
    }
}
