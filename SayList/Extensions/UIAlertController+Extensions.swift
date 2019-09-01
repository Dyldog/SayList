//
//  UIAlertController.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addOKAction(title: String = "OK", style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) {
        addAction(UIAlertAction(title: title, style: style, handler: handler))
    }
}
