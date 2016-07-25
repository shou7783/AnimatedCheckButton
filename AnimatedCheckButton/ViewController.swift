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
        
        let button = AnimatedCheckButton(frame: CGRectMake(100, 50, 200, 50))
        button.lineWidth = 50
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Top, relatedBy: .Equal, toItem: button, attribute: .Top, multiplier: 1, constant: -50))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: button, attribute: .Bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Leading, relatedBy: .Equal, toItem: button, attribute: .Leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Trailing, relatedBy: .Equal, toItem: button, attribute: .Trailing, multiplier: 1, constant: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

