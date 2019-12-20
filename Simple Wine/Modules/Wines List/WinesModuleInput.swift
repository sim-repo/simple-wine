import Foundation

protocol WinesModuleInput {
    var didSelectWine: ((Int, String) -> Void)? { get set }
    func loadWines(for subCategory: Category, filters: [[String]], title: String)
    func loadSearchWines(wines: [Product], searchString: String)
}

var didSelectWine: ((String, String) -> Void)?
