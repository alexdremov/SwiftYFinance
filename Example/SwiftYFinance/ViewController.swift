//
//  ViewController.swift
//  SwiftYFinance
//
//  Created by AlexRoar on 08/11/2020.
//  Copyright (c) 2020 AlexRoar. All rights reserved.
//

import UIKit
import SwiftYFinance

class ViewController: UIViewController {

    override func viewDidLoad() {
        try! SwiftYFinance.fetchSearchDataBy(searchTerm: "AAPL"){data in
            
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

