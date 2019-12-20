//
//  WinesListViewController.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 04/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

class WinesListViewController: UIViewController {

    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var volumeLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Instance Properties
    var viewModel: WinesListModel! {
        didSet { bind() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        volumeLabel.textColor = AppTheme.highlighted
        countryLabel.textColor = AppTheme.unselected
        tableView.dataSource = viewModel
        tableView.registerViewModel(WinesMainViewModel.self)
    }


}

private extension WinesListViewController {
    
    private func bind() {
        viewModel.onRefreshTable = { [weak self](wines) in
            guard let `self` = self else { return }
            self.tableView.reloadData()
            if (wines.count > 0) {
                self.countryLabel.text = self.viewModel.productsTitle
                if self.viewModel.volumeTitle == 1.5 {
                    self.volumeLabel.text = "1,5 л"
                } else if self.viewModel.volumeTitle == 0.375 {
                    self.volumeLabel.text = "0,375 л"
                } else {
                    self.volumeLabel.text = "0,75 л"
                }
            } else {
                self.countryLabel.text = ""
                self.volumeLabel.text = ""
            }
        }
        
        viewModel.onWinesDidLoad = { [weak self] wines in
            guard let `self` = self else { return }
            UI_THREAD {
                if (wines.count > 0) {
                    self.countryLabel.text = self.viewModel.productsTitle
                    if self.viewModel.volumeTitle == 1.5 {
                        self.volumeLabel.text = "1,5 л"
                    } else if self.viewModel.volumeTitle == 0.375 {
                        self.volumeLabel.text = "0,375 л"
                    } else {
                        self.volumeLabel.text = "0,75 л"
                    }
                } else {
                    self.countryLabel.text = ""
                    self.volumeLabel.text = ""
                }
                if (wines.isEmpty) {
                    var title = ""
                    if self.viewModel.productsTitle.contains("Поиск") {
                        title = "Нет продуктов, подходящих под критерии поиска."
                    } else {
                        title = "Данные для категории пока что не загружены."
                    }
                    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: Localization.Common.OK, style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                self.tableView.reloadData()
                
                if !wines.isEmpty { self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true) }
            }
        }
    }
}

extension WinesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectWine(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.sortedGroupsTitles[section] == "" {
            return 0.0
        }
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = AppTheme.background
        label.text = viewModel.sortedGroupsTitles[section]
        label.font = AppFont.charterBold(ofSize: 17)
        label.textColor = AppTheme.unselected
        label.textAlignment = .left
        return label
    }
    
}
