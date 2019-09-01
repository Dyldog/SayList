//
//  ViewController.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

class PlaylistListViewModel: CellListViewModel<SimpleCellModel> {}

class PlaylistListViewController: ListTableViewController<PlaylistListViewModel, PlayListListPresenter>, PlaylistListDisplay {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}



