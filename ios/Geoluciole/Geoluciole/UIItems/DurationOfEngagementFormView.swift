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

    fileprivate var dateStartField: SettingsDateFieldView!
    fileprivate var dateEndField: SettingsDateFieldView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        /*
         Récupère les dates données dans le formulaire si elles existent ou founit la date du jour. Pour la date de début et la date de fin.
         */
        let beginDateStr = UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_ENGAGEMENT, defaultValue:  UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_STAY))
        
        //let beginDate = Tools.convertDate(date: beginDateStr)

        let endDateStr = UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_ENGAGEMENT, defaultValue: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_STAY))
        //let endDate = Tools.convertDate(date: beginDateStr)

        let title = CustomUILabel()
        title.text = Tools.getTranslate(key: "dates_settings")
        title.setStyle(style: .subtitleBold)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left
        self.addSubview(title)

        /*
         dateStartField comprend un sous titre (Start date), un textview pour afficher la date sélectionnée
         et un datePicker pour choisir une nouvelle date
         */
        self.dateStartField = SettingsDateFieldView()
        self.dateStartField.validationData = { [weak self] uitextview in
            guard let strongSelf = self else {
                return false
            }
            var incomeDate: Date

            if let date = uitextview.text, date != "" {
                incomeDate = Tools.convertDate(date: date)
            } else {
                incomeDate = Date()
            }

            let result = incomeDate.timeIntervalSince1970 <= Tools.convertDate(date: strongSelf.dateEndField.getDateLabel()).timeIntervalSince1970
            if !result {
                strongSelf.dateStartField.setDateLabel(date:  UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_ENGAGEMENT))
            }
            return result

        }
        self.dateStartField.setTitle(title: Tools.getTranslate(key: "dates_settings_start"))
        self.dateStartField.setDateLabel(date: beginDateStr)
        self.dateStartField.setMinimumDate(date: Tools.convertDate(date: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_STAY)))
        self.dateStartField.setMaximumDate(date: Tools.convertDate(date: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_STAY)))
        self.dateStartField.setDefaultDatePicker(date: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_STAY))
        
        self.dateStartField.translatesAutoresizingMaskIntoConstraints = false
        self.dateStartField.onDateValidate = { date in
            UserPrefs.getInstance().setPrefs(key: UserPrefs.KEY_DATE_START_ENGAGEMENT, value: Tools.convertDate(date: date))
        }
        self.addSubview(dateStartField)
        
        /*
         idem que dateStartField mais pour la fin d'engagement
         */
        self.dateEndField = SettingsDateFieldView()
        self.dateEndField.validationData = { [weak self] uitextview in
            guard let strongSelf = self else {
                return false
            }
            var incomeDate: Date

            if let date = uitextview.text, date != "" {
                incomeDate = Tools.convertDate(date: date)
            } else {
                incomeDate = Date()
            }

            let result = incomeDate.timeIntervalSince1970 >= Tools.convertDate(date: strongSelf.dateStartField.getDateLabel()).timeIntervalSince1970
            if !result {
                strongSelf.dateEndField.setDateLabel(date:  UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_ENGAGEMENT))
            }
            return result

        }
        self.dateEndField.setMinimumDate(date: Tools.convertDate(date: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_START_STAY)))
        self.dateEndField.setMaximumDate(date: Tools.convertDate(date: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_STAY)))
        self.dateEndField.setDefaultDatePicker(date: UserPrefs.getInstance().string(forKey: UserPrefs.KEY_DATE_END_STAY))
        self.dateEndField.setDateLabel(date: endDateStr)
        self.dateEndField.setTitle(title: Tools.getTranslate(key: "dates_settings_end"))
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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
