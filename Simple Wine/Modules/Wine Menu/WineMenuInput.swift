//
//  WineMenuInput.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 04/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

protocol WineMenuInput {
    
    var heightForView: CGFloat { get }
    var didCategorySelect: ((Category, UInt) -> Void)? { get set }
    func loadWineMenu(for category:Category)
    func selectFirst()
}
