//
//  Habit.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/27/24.
//

import Foundation
import SwiftData
import FirebaseFirestore
import FirebaseAuth

// TODO: What does the encodable and decodable do?
enum FrequencyAmount: String, Encodable, Decodable, CaseIterable {
    case one, two, three, four, five
}

class Habit: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var habitName: String
    var frequency: FrequencyAmount
    var description: String
    var completedForTheDay: [Bool]
    var dateCreated: Date
    var totalCompleted: Int
    var totalMissed: Int
    var reminderIsOn: Bool 
    var lastCompleted: Date?
    
    init(id: String? = nil, userId: String = (Auth.auth().currentUser?.uid ?? ""), habitName: String = "", frequency: FrequencyAmount = .one, description: String = "", dateCreated: Date = Date.now, totalCompleted: Int = 0, totalMissed: Int = 0, reminderIsOn: Bool = false, lastCompleted: Date? = nil) {
        self.userId = userId
        self.habitName = habitName
        self.frequency = frequency
        self.description = description
        self.completedForTheDay = Array(repeating: false, count: 4)
        self.dateCreated = dateCreated
        self.totalCompleted = totalCompleted
        self.totalMissed = totalMissed
        self.reminderIsOn = reminderIsOn
        self.lastCompleted = lastCompleted
    }
    
}
