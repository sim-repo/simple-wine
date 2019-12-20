//
//  CategoriesModuleInput.swift
//  Simple Wine
//
//  Created by Ivan Babich on 20/10/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation

protocol CategoriesModuleInput {
    var didCategorySelect: ((Category) -> Void)? { get set }
    func selectFirst()
}
