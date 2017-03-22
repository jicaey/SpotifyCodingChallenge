//
//  PersonCell.swift
//  SpotifyCodingChallenge
//
//  Created by Michael Young on 3/21/17.
//  Copyright © 2017 Michael Young. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = avenirBook
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = avenirBook
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .clear
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        
        addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }

    }
    
    

}
