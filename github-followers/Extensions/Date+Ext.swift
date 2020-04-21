//
//  Date+Ext.swift
//  github-followers
//
//  Created by Theodor Valiavko on 21/04/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
