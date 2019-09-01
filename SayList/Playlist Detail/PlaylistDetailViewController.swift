//
//  PlaylistDetailViewController.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

class PlaylistDetailViewModel: CellListViewModel<SimpleCellModel> {}

class PlaylistDetailViewController: ListTableViewController<PlaylistDetailViewModel, PlaylistDetailPresenter>, PlaylistDetailDisplay {
}
