//
//  DiijkstraViewController.swift
//  Diijkstra
//
//  Created by Mykola Savoniuk on 2/15/18.
//  Copyright © 2018 Mykola Savoniuk. All rights reserved.
//

import UIKit

class DiijkstraViewController: UIViewController {
    // MARK: - Properties
    var PhilosophersArray = [Philosopher]()
    var names = ["First","Second","Third","Fourth","Fifth"]
    let semaphore = DispatchSemaphore(value: 1)
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - Internal
    func start() {
        for index in 0...4 {
            self.PhilosophersArray.append(Philosopher(name: self.names[index]))
        }
        
        let queue = DispatchQueue.global(qos: .background)
        
        while (true) {
            queue.async {
                self.startProcess(with: Int(arc4random_uniform(5)))
            }
        }
    }
    
    func startProcess(with index:Int) {
        let object = self.PhilosophersArray[index]
        
        let leftPhilosopherCount = index > 0 ? index - 1 : 4
        let rightPhilosopherCount = index < 4 ? index + 1 : 0
        
        self.semaphore.wait()
        if object.checkSurrounding(leftObject: self.PhilosophersArray[leftPhilosopherCount], rightObject: self.PhilosophersArray[rightPhilosopherCount]) {
            object.eat()
            print("start", index)
        }
        
        self.semaphore.signal()
    }
    
}

enum PhilosopherState {
    case eat
    case think
}

class Philosopher {
    let name: String
    var state: PhilosopherState = .think

    init(name: String) {
        self.name = name
    }
    
    func eat() {
        self.state = .eat
        sleep(2)
        self.state = .think
    }
    
    func checkSurrounding(leftObject: Philosopher, rightObject: Philosopher) -> Bool {
        var result = false
        
        if leftObject.state == .think && rightObject.state == .think {
            result = true
        }
        
        return result
    }
}
