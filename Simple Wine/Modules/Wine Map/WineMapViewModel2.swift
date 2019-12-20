//
//  WineMapViewModel2.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 03/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

class WineMapViewModel2: NSObject, WineMapModuleInput {
    
    private let authService: AuthService
    private let dataStorage: ProductDetailDataStorage
    var wineMapMode: WineMapMode = .classic
    private(set) var selectedWines: [ProductDetail] = []
    
    init(authService: AuthService = AuthServiceImplementation()) {
        self.authService = authService
        self.dataStorage = ProductDetailDataStorage()
        super.init()
        
        reloadData()
    }

    func reloadData() {
        selectedWines = dataStorage.fetchFavourites()
    }
}
