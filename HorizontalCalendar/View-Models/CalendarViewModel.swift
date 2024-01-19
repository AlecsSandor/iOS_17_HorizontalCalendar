//
//  CalendarViewModel.swift
//  HorizontalCalendar
//
//  Created by Alex on 1/19/24.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var selectedIndex: Int = 10
    @Published var daysInterval: [String] = []
    @Published var selectedDate: DateModel = DateModel(day: 10, month: 1, year: 2024)
    @Published var isScrollViewReady: Bool = false

    func numberOfDays(in month: Int, year: Int) {
        let calendar = Calendar.current
        
        // Create a date components object for the first day of the current month
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        // Calculate the first day of the current month
        if let currentMonthFirstDay = calendar.date(from: components),
           let lastDay = calendar.date(byAdding: .month, value: 1, to: currentMonthFirstDay)?.addingTimeInterval(-1) {
            // Extract the day component from the last day to get the total number of days in the current month
            let numberOfDays = calendar.component(.day, from: lastDay)
            
            // Get the day names for each day in the month
            let dayNames = (1...numberOfDays).compactMap { (day) -> String? in
                let currentDate = calendar.date(bySetting: .day, value: day, of: currentMonthFirstDay)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE" // "EEEE" gives the full day name
                return currentDate.map { dateFormatter.string(from: $0) }
            }
            createDaysOfMonth(days: dayNames)
        }
    }
    
    // Populates the daysInterval with days and their names
    func createDaysOfMonth(days: [String]) {
        daysInterval = days
    }

    // Updating the selected index based on position -  it uses a static formal since every non selected item has a width of 71 and the selected position has 95
    func updateSelectedIndex(scrollPosition: CGPoint) {
        if selectedIndex == 0 {
            selectedIndex = Int(scrollPosition.x) / -95
            selectedDate.day = Int(scrollPosition.x) / -95 + 1
        } else {
            selectedIndex = Int(scrollPosition.x) / -71
            selectedDate.day = Int(scrollPosition.x) / -71 + 1
        }
    }

    func updateSelectedDate(newDate: DateModel) {
        selectedDate = newDate
    }
}
