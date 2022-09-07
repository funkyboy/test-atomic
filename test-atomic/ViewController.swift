//
//  ViewController.swift
//  test-atomic
//
//  Created by Cesare Rocchi on 07/09/22.
//

import UIKit

class ViewController: UIViewController {
    let manager = TaskManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.concurrentPerform(iterations: 100) { _ in        
            manager.load()
        }
        print("final manager objects \(manager.objects)")
    }
}

