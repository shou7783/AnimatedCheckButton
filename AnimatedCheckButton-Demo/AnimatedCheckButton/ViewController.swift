//
//  ViewController.swift
//  AnimatedCheckButton
//
//  Created by MengHsiu Chang on 7/22/16.
//  Copyright © 2016 shou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = AnimatedCheckButton(frame: CGRectMake(100, 50, 200, 200))
        button.lineWidth = 10
        self.view.addSubview(button)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

