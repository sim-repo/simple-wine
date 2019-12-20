import Foundation

final class WineMapViewModel: NSObject, WineMapModuleInput {
    
    private let authService: AuthService
    private let dataStorage: ProductDetailDataStorage
    var wineMapMode: WineMapMode = .classic
    private(set) var selectedWines: [ProductDetail] = []
    var didSelectedWinesChange: (() -> Void)?
    
    init(authService: AuthService = AuthServiceImplementation()) {
        self.authService = authService
        self.dataStorage = ProductDetailDataStorage()
        super.init()
        
        reloadData()
    }
    
    func reloadData() {
        selectedWines = dataStorage.fetchFavourites()
    }
    
    func selectWine(wine: ProductDetail) {
        reloadData()
        
        didSelectedWinesChange?()
    }
    
    func deleteSelectedFavorites(wines: [ProductDetail]) {
        self.dataStorage.setFavourite(false, for: wines)
        
        reloadData()
        didSelectedWinesChange?()
    }
    
}
