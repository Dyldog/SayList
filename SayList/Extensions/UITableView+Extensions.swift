//
//  UITableView+Extensions.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueOrCreateCell<T>(identifier: String? = nil, style: UITableViewCell.CellStyle = .default) -> T where T: UITableViewCell {
        let reuseIdentifier = identifier ?? String(describing: type(of: T.self))
        return dequeueReusableCell(withIdentifier: reuseIdentifier) as? T ?? T(style: style, reuseIdentifier: reuseIdentifier)
    }
}
