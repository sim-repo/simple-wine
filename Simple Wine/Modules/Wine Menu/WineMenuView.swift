//
//  WineMenuView.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 04/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

class WineMenuView: UIView {

    var viewModel: WineMenuModel! {
        didSet {
            bind()
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    private var isTouchFirst = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isTouchFirst = false
        tableView.tableHeaderView?.frame.size.height = 29
        tableView.registerViewModel(WineTypeCellViewModel.self)
        translatesAutoresizingMaskIntoConstraints = false
    }

}

extension WineMenuView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(indexPath: indexPath)
    }
}

private extension WineMenuView {
    
    private func bind() {
        tableView.dataSource = viewModel
        viewModel.didFirstSelected = touchFirst
        viewModel.didCategoriesLoad = { [weak self] _ in
            guard let `self` = self else { return }
            UI_THREAD {
                self.tableView.reloadData()
                if self.isTouchFirst {
                    self.setFirst()
                }
            }
        }
    }
    
    func touchFirst() {
        guard viewModel.categories.count > 0 else { return }
        
        let indexPath = IndexPath(row: 0, section: 0)
        isTouchFirst = true
        setFirst()
        viewModel.select(indexPath: indexPath)
    }
    
    func setFirst() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
}
