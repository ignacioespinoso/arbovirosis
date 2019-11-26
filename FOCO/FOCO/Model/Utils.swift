//
//  Utils.swift
//  FOCO
//
//  Created by Beatriz Viseu Linhares on 21/11/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import Foundation

class Utils: NSObject {

    static func fixDateFormat(inputDate: String) -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: inputDate) else {
          preconditionFailure("Your input format is unexpected. Please follow the format: 'yyyy-MM-dd'T'HH:mm:ss.SSSZ'")
        }
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fixedDate = dateFormatter.string(from: date)
        return fixedDate
    }
}
