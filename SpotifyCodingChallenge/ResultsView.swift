//
//  ResultsView.swift
//  SpotifyCodingChallenge
//
//  Created by Michael Young on 3/19/17.
//  Copyright © 2017 Michael Young. All rights reserved.
//

import UIKit
import SnapKit

class LeftPaddedTextField: UITextField {
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
        // TODO: Make responsive
        textView.contentInset = UIEdgeInsets(top: 25, left: 80, bottom: 0, right: -80)
        textView.font = avenirMedium
        textView.textColor = .white
        textView.textAlignment = .left
        return textView
    }()
    
    let nameTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.backgroundColor = colorTwo.withAlphaComponent(0.5)
        textField.layer.cornerRadius = 5
        textField.alpha = 0
        textField.textAlignment = .left
        textField.font = avenirBoldMedium
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
        textField.font = avenirBoldMedium
        textField.textColor = .white
        textField.placeholder = "What is your Favorite City?"
        return textField
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = colorTwo
        button.layer.cornerRadius = 5
        button.alpha = 0
        button.titleLabel?.font = avenirSmall
        button.addTarget(nil, action: #selector(HomeViewController.submitButtonTouched), for: .touchUpInside)
        button.setTitle("Post", for: .normal)
        button.setTitle("Done", for: .selected)
        return button
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
            make.width.equalTo(resultsTextView).multipliedBy(0.7)
        }
        
        addSubview(cityTextField)
        cityTextField.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.centerX.equalTo(resultsTextView)
            make.width.equalTo(resultsTextView).multipliedBy(0.7)
        }
        
        addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityTextField.snp.bottom).offset(20)
            make.width.equalTo(cityTextField).multipliedBy(0.5)
        }


    }
}
