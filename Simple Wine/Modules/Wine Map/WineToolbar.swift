//
//  WineToolbar.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 23/04/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import UIKit

final class WineToolbar: UIView {
    
    var searchClicked: ((String?) -> Void)?

    private(set) lazy var searchBar: UISearchBar = { [weak self] in
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.placeholder = "Поиск по названию"
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        addSubview(searchBar)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = CGRect(x: width - 240, y: (height - 40) / 2, width: 240, height: 40)
    }
}

// MARK: - Search button & UISearchBarDelegate
extension WineToolbar: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBarWidth.constant = 450
//        cancelSearchButton.isHidden = false
//        UIView.animate(withDuration: 0.4) {
//            self.view.layoutIfNeeded()
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        searchClicked!(searchBar.text)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBarWidth.constant = 250
//        cancelSearchButton.isHidden = true
//        UIView.animate(withDuration: 0.4) {
//            self.view.layoutIfNeeded()
//        }
    }
}

