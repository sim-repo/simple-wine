import UIKit

typealias WineCellViewModel = WinesMainViewModel

protocol WinesViewModelProtocol: class {
    var onWinesDidLoad: (([Product]) -> Void)? { get set }
    var onWinesDidFail: ((SWError) -> Void)? { get set }
    func selectWine(indexPath: IndexPath)
}

final class WinesViewModel: NSObject, WinesViewModelProtocol, WinesModuleInput {
    
    // MARK: - Instance Properties
    
    var onWinesDidLoad: (([Product]) -> Void)?
    var onWinesDidFail: ((SWError) -> Void)?
    var didSelectWine: ((Int, String) -> Void)?
    var productsTitle = ""
    var volumeTitle = 0.0
    var sortedGroupsTitles = [String]()
    var isCountry = true
    private var sortedWines = [[Product]]()
    private var isСhampagne = false
    
    
    // MARK: - Instance Method
    
    private func sorted(wines: [Product]) {
        isCountry = true
        for wine in wines {
            guard let countryName = wine.country?.name, !sortedGroupsTitles.contains(countryName) else {
                continue
            }
            sortedGroupsTitles.append(countryName)
        }
        if sortedGroupsTitles.count <= 1 /* && !(sortedGroupsTitles.count == 1 && sortedGroupsTitles.first != productsTitle) */ {
            sortedGroupsTitles.removeAll()
            isCountry = false
            for wine in wines {
                guard let region = wine.region, !sortedGroupsTitles.contains(region) else {
                    continue
                }
                sortedGroupsTitles.append(region)
            }
        }
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
                group.sort { $0.hallPrice < $1.hallPrice }
                sortedWines.append(group)
            } else {
                for wine in wines {
                    guard let region = wine.region else {
                        continue
                    }
                    if title == region {
                        group.append(wine)
                    }
                }
                group.sort { $0.hallPrice < $1.hallPrice }
                sortedWines.append(group)
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
            for i in 0..<sortedGroupsTitles.count {
                sortedGroupsTitles[i] = ""
            }
        }
        onWinesDidLoad?(wines)
    }
    
    func loadWines(for category: Category, filters: [[String]], title: String) {
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
        
        isСhampagne = (category.categoryId == 1024)
        sorted(wines: wines)
    }
    
    func loadSearchWines(wines: [Product], searchString: String) {
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

// MARK: - UITableViewDataSource

extension WinesViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sortedGroupsTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedWines[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wine = sortedWines[indexPath.section][indexPath.row]
        var wineTitle = wine.name ?? ""
        if let manufacturer = wine.manufacturer {
            wineTitle += ", \(manufacturer)"
        }
        if isCountry, !isСhampagne, let region = wine.region, region.count > 0 {
            wineTitle += ", \(region)"
        }
        return WinesMainViewModel(year: wine.year, title: wineTitle, price: wine.hallPrice).cell(for: tableView)
    }
    
}
