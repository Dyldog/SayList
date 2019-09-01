//
//  ListViewController.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

protocol ListViewModel {
    init()
    var numberOfRows: Int { get }
    func titleForRow(at index: Int) -> String
    func subtitleForRow(at index: Int) -> String?
}

protocol CellModel {
    var title: String { get }
    var subtitle: String? { get }
}

extension CellModel {
    var subtitle: String? { return nil }
}

struct SimpleCellModel: CellModel {
    let title: String
    let subtitle: String?
}

struct Test: CellModel {
    var title: String
}

class CellListViewModel<CM>: ListViewModel where CM: CellModel {
    required init() {
        cellModels = []
    }
    
    private let cellModels: [CellModel]
    
    var numberOfRows: Int { return cellModels.count }
    
    func titleForRow(at index: Int) -> String {
        return cellModels[index].title
    }
    
    func subtitleForRow(at index: Int) -> String? {
        return cellModels[index].subtitle
    }
    
    init(cellModels: [CellModel]) {
        self.cellModels = cellModels
    }
}

class ListTableViewController<ViewModel, Presenter>: UIViewController, Display, UITableViewDelegate, UITableViewDataSource where ViewModel: ListViewModel, Presenter: ListPresenter {
    var presenter: Presenter?
    var viewModel: ViewModel = .init()
    let tableView: UITableView
    
    init() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.embed(in: self.view)
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter?.displayWillShow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueOrCreateCell(style: .subtitle)
        cell.textLabel?.text = viewModel.titleForRow(at: indexPath.row)
        cell.detailTextLabel?.text = viewModel.subtitleForRow(at: indexPath.row)
        return cell
    }
    
    func setViewModel(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
}
