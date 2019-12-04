//
//  Util.swift
//  PushDemo
//
//  Created by GZOffice_hao on 2019/12/3.
//  Copyright © 2019 vito. All rights reserved.
//

import Foundation

let defaultDateFormat = "yyyy-MM-dd HH:mm:ss"

extension Date {
    func toDisplayString(format: String = defaultDateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func toDate(format: String = defaultDateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
