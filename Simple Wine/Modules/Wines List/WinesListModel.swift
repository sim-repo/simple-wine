//
//  WinesListModel.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 04/10/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

class WinesListModel: NSObject, WinesListInput {

    var didSelectWine: ((Int, String) -> Void)?
    var onWinesDidLoad: (([Product]) -> Void)?
    var onRefreshTable: (([Product])->())?
    
    var productsTitle = ""
    var volumeTitle = 0.0
    var sortedGroupsTitles = [String]()
    var isCountry = true
    var isAddRegion = true
    
    private var sortedWines = [[Product]]()
    private var isСhampagne = false
    
    func clearWines(){
        sortedGroupsTitles.removeAll()
        sortedWines.removeAll()
        productsTitle = ""
        volumeTitle = 0.0
        onRefreshTable?([])
    }
    
    func loadWines(for category: Category, filters: [[String]], title: String){
        sortedGroupsTitles.removeAll()
        sortedWines.removeAll()
        self.productsTitle = title
        volumeTitle = 0.0
        for filter in filters {
            if filter.count == 2 {
                if filter[0].contains("volume") && filter[1].contains("1.5") {
                    volumeTitle = 1.5
                }
                if filter[0].contains("volume") && filter[1].contains("0.375") {
                    volumeTitle = 0.375
                    break
                }
            }
        }
        
        let dataStorage = ProductDataStorage()
        let wines = dataStorage.fetchProducts(for: category) as! [Product]
        
        isСhampagne = false
        var parent = category
        while parent.parentCategory != nil { parent = parent.parentCategory! }
        isСhampagne = parent.name.lowercased().hasPrefix("шамп")
        sorted(wines: wines)
    }
    
    func loadSearchWines(wines: [Product], searchString: String){
        sortedGroupsTitles.removeAll()
        sortedWines.removeAll()
        self.productsTitle = "Поиск по строке: \"\(searchString)\""
        sorted(wines: wines)
    }
    
    func selectWine(indexPath: IndexPath) {
        let wine = sortedWines[indexPath.section][indexPath.row]
        didSelectWine?(wine.bitrixId, wine.name ?? "")
    }
}

extension WinesListModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedGroupsTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedWines[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wine = sortedWines[indexPath.section][indexPath.row]
        var wineTitle = wine.name ?? ""
        if let manufacturer = wine.manufacturer {
            wineTitle += ", \(manufacturer)"
        }
//        if isCountry, !isСhampagne, let region = wine.region, region.count > 0 {
//            wineTitle += ", \(region)"
//        }
        if isAddRegion, let region = wine.region, region.count > 0 {
            wineTitle += ", \(region)"
        }
        return WinesMainViewModel(year: wine.year, title: wineTitle, price: wine.hallPrice).cell(for: tableView)
    }
    
}

private extension WinesListModel {
    
    func sorted(wines: [Product]) {
        
        func wineSort(_ products: [Product]) -> [Product] {
            var products = products
            //products.sort { $0.hallPrice < $1.hallPrice }
            
            products.sort { $0.hallPrice < $1.hallPrice }
            var out = [Product]()
            var first: Product
            var group = [Product]()
            while products.count > 0 {
                first = products.first!
                group = products.filter { $0.name == first.name }
                group.sort{
                    if $0.hallPrice == $1.hallPrice { return $1.year > 0 && $0.year > $1.year }
                    else { return $0.hallPrice < $1.hallPrice }
                }
                out.append(contentsOf: group)
                products.removeAll { group.contains($0) }
            }
            return out
        }
        
        isCountry = true
        isAddRegion = true
        sortedGroupsTitles = Array(Set(wines.compactMap{$0.country?.name}))
        if sortedGroupsTitles.count <= 1 {
            var regions = Set(wines.compactMap{$0.region})
            if regions.count == 0 { regions.insert("") }
            if !(sortedGroupsTitles.count == 1 && sortedGroupsTitles.first != productsTitle) {
                sortedGroupsTitles = Array(regions)
                isCountry = false
                isAddRegion = false
            } else if regions.count == 1 {
                isAddRegion = false
            }
            
        }
//        for wine in wines {
//            guard let countryName = wine.country?.name, !sortedGroupsTitles.contains(countryName) else {
//                continue
//            }
//            sortedGroupsTitles.append(countryName)
//        }
//        if sortedGroupsTitles.count <= 1 && !(sortedGroupsTitles.count == 1 && sortedGroupsTitles.first != productsTitle) {
//            sortedGroupsTitles.removeAll()
//            isCountry = false
//            for wine in wines {
//                guard let region = wine.region, !sortedGroupsTitles.contains(region) else {
//                    continue
//                }
//                sortedGroupsTitles.append(region)
//            }
//        }
        let sortedArray = sortedGroupsTitles.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        sortedGroupsTitles = sortedArray
        for title in sortedGroupsTitles {
            var group = [Product]()
            if isCountry {
                for wine in wines {
                    if title == wine.country?.name {
                        group.append(wine)
                    }
                }
                
                sortedWines.append(wineSort(group))
            } else {
                for wine in wines {
                    let region = wine.region ?? ""
                    if title == region {
                        group.append(wine)
                    }
                }
                sortedWines.append(wineSort(group))
            }
            
        }
        
        for wine in wines {
            if wine.region == productsTitle {
                sortedGroupsTitles[0] = ""
                break
            }
            if sortedGroupsTitles.count == 1 && productsTitle != wine.country?.name {
                sortedGroupsTitles[0] = wine.country?.name ?? "Страна без названия"
                isCountry = true
                break
            }
        }
        
        if isСhampagne {
            isAddRegion = false
            for i in 0..<sortedGroupsTitles.count {
                sortedGroupsTitles[i] = ""
            }
        }
        onWinesDidLoad?(wines)
    }
    
}
