//
//  ViewController.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

struct PlaylistListViewModel {
    struct CellModel {
        let title: String
        let subtitle: String
    }
    
    let cellModels: [CellModel]
    
    init(cellModels: [CellModel]) {
        self.cellModels = cellModels
    }
    
    var numberOfRows: Int { return cellModels.count }
    
    func titleForRow(at index: Int) -> String {
        return cellModels[index].title
    }
    
    func subtitleForRow(at index: Int) -> String {
        return cellModels[index].subtitle
    }
}

class PlaylistListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlaylistListDisplay {

    var presenter: PlayListListPresenter!
    var viewModel: PlaylistListViewModel!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = PlayListListPresenter(display: self)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.embed(in: self.view)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    func setViewModel(_ viewModel: PlaylistListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueOrCreateCell(style: .subtitle)
        cell.textLabel?.text = viewModel.titleForRow(at: indexPath.row)
        cell.detailTextLabel?.text = viewModel.subtitleForRow(at: indexPath.row)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}



