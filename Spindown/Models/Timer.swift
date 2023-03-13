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
        self.running = true
        self.endDate = Calendar.current.date(byAdding: .minute, value: self.startTime, to: Date())!
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
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.minute, .second], from: now, to: endDate)
        let minutes = components.minute
        let seconds = components.second
        
        self.minutes = Float(minutes ?? 0)
        self.time = String(format: "%d:%02d", minutes ?? 0, seconds ?? 0)
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
