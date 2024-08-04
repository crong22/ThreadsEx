//
//  Birthday.swift
//  RxThreadsEx
//
//  Created by Woo on 8/4/24.
//

import Foundation

struct Birth {
    let currentDate: Date
    let yearCurrent: Int
    let monthCurrent: Int
    let dayCurrent: Int
    
    init() {
        self.currentDate = Date()
        let calendar = Calendar.current
        self.yearCurrent = calendar.component(.year, from: currentDate)
        self.monthCurrent = calendar.component(.month, from: currentDate)
        self.dayCurrent = calendar.component(.day, from: currentDate)
    }
}
