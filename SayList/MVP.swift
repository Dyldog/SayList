//
//  MVP.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

protocol Display {
    func showAlert(title: String, message: String)
}

protocol Presenter {
    mutating func displayWillShow()
}

protocol ListPresenter: Presenter {
    func didSelectRow(at indexPath: IndexPath)
}
