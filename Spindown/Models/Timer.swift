//
//  Timer.swift
//  Spindown
//
//  Created by Tyler Reckart on 3/3/23.
//
import SwiftUI

class GameTimerModel: ObservableObject {
    @Published var running: Bool = false
    @Published var showDialog: Bool = false
    @Published var time: String = "0:00"
    @Published var minutes: Float = 30.0 {
        didSet {
            self.time = "\(Int(self.minutes)):00"
        }
    }
    
    private var startTime: Int = 0
    private var endDate = Date()
    
    public func start(_ minutes: Float) -> Void {
        self.minutes = minutes
        self.startTime = Int(self.minutes)
        self.endDate = Date()
        self.running = true
        self.endDate = Calendar.current.date(byAdding: .minute, value: self.startTime, to: self.endDate)!
    }
    
    public func update() -> Void {
        guard self.running else { return }
        
        let now = Date()
        let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
        
        if (diff <= 0) {
            withAnimation {
                self.running = false
                self.minutes = 0
                self.showDialog = true
            }
        }
        
        let date = Date(timeIntervalSince1970: diff)
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        self.minutes = Float(minutes)
        self.time = String(format: "%d:%02d", minutes, seconds)
        print("Time Remaining: \(self.time)")
    }
    
    public func reset() -> Void {
        withAnimation {
            self.showDialog = false
            self.running = false
            self.minutes = 30.0
        }
    }
}
