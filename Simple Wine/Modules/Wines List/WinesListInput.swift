//
//  WinesListInput.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 04/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import Foundation

protocol WinesListInput {
    var didSelectWine: ((Int, String) -> Void)? { get set }
    func loadWines(for subCategory: Category, filters: [[String]], title: String)
    func loadSearchWines(wines: [Product], searchString: String)
}
