//
//  DurationOfEngagementFormView.swift
//  Geoluciole
//
//  Created by Thibaud LAMBERT on 14/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import Foundation
import UIKit

class DurationOfEngagementFormView: UIView {

    fileprivate var dateStartField : SettingsDateFieldView!
    fileprivate var dateEndField : SettingsDateFieldView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let minimumDate = Date()
        let minimumDateString = Tools.convertDate(date: minimumDate)

        let title = CustomUILabel()
        title.text = Tools.getTranslate(key: "dates_settings")
        title.setStyle(style: .subtitleBold)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        self.addSubview(title)

        self.dateStartField = SettingsDateFieldView()
        self.dateEndField = SettingsDateFieldView()
        
        self.dateStartField.setTitle(title: Tools.getTranslate(key: "dates_settings_start"))
        self.dateStartField.setDateLabel(date: minimumDateString)
        if UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_ENGAGEMENT) != "" {
            let dateValue = UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_ENGAGEMENT)
            self.dateStartField.setDateLabel(date: dateValue)
            self.dateEndField.setMinimumDate(date: Tools.convertDate(date: dateValue))
        }
        self.dateStartField.setMinimumDate(date: minimumDate)
        
        self.dateStartField.translatesAutoresizingMaskIntoConstraints = false
        self.dateStartField.onDateValidate = { date in
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_START_ENGAGEMENT, value: Tools.convertDate(date: date))
        }
        self.addSubview(dateStartField)

        
        self.dateEndField.setMinimumDate(date: minimumDate)
        self.dateEndField.setDateLabel(date: minimumDateString)
        self.dateEndField.setTitle(title: Tools.getTranslate(key: "dates_settings_end"))
        if UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_ENGAGEMENT) != "" {
            let dateValue = UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_ENGAGEMENT)
            dateEndField.setDateLabel(date: dateValue)
            self.dateStartField.setMaximumDate(date: Tools.convertDate(date: dateValue))
        }
        self.dateEndField.translatesAutoresizingMaskIntoConstraints = false
        self.dateEndField.onDateValidate = { date in
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_END_ENGAGEMENT, value: Tools.convertDate(date: date))
        }
        self.addSubview(dateEndField)

        NSLayoutConstraint.activate([

            self.bottomAnchor.constraint(equalTo: dateStartField.bottomAnchor),

            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.widthAnchor.constraint(equalTo: self.widthAnchor),
            title.leftAnchor.constraint(equalTo: self.leftAnchor),
            title.rightAnchor.constraint(equalTo: self.rightAnchor),

            self.dateStartField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.dateStartField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.dateStartField.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.dateStartField.rightAnchor.constraint(equalTo: dateEndField.leftAnchor),

            self.dateEndField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.dateEndField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.dateEndField.leftAnchor.constraint(equalTo: dateStartField.rightAnchor),
            self.dateEndField.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    
//    func setStartDate(date: Date){
//        self.dateStartField.setDate(date: date)
//    }
//
//    func setEndDate(date: Date){
//        self.dateEndField.setDate(date: date)
//    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
