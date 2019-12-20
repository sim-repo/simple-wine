import Foundation
import UIKit

final class DetailWineViewModel: DetailWineModuleInput {
    
    private var authService: AuthService
    private let wineService: WineService
    private let imageService: ImageService
    private var wine: ProductDetail? = nil {
        didSet {
            UI_THREAD {
                self.updateWinePropertyItems()
                self.onBitrixDidChanged?()
            }
        }
    }
    private var error: SWError? {
        set {
            guard newValue != nil else { return }
            _error = newValue
            UI_THREAD { self.onErrorOccured?(newValue!) }
        }
        get {
            return _error
        }
    }
    private var bitrix_id: Int?
    private var imageDownloadTask: URLSessionTask? = nil {
        willSet {
            imageDownloadTask?.cancel()
        }
    }
    private var flagImageDownloadTask: URLSessionTask? = nil {
        willSet {
            flagImageDownloadTask?.cancel()
        }
    }
    private var wineFetchTask: URLSessionTask? = nil {
        willSet {
            wineFetchTask?.cancel()
        }
    }
    private var _isActivityIndicatorAnimating: Bool = false
    private var _error: SWError?
    var winePropertyItems: [WinePropertyItem] = []
    var countryFlagImage: UIImage? {
        didSet {
            updateWinePropertyItems()
            onFlagImageDidLoaded?()
        }
    }
    var wineImage: UIImage? {
        didSet {
            onImageDidLoaded?()
        }
    }
    
    var didClose: (() -> Void)?
    var didWineLike: ((ProductDetail) -> Void)?
    var isLikedChanged: (() -> Void)?
    var onBitrixDidChanged: (() -> Void)?
    var onImageDidLoaded: (() -> Void)?
    var onFlagImageDidLoaded: (() -> Void)?
    var onAcitivityIndicatorStateChanged: (() -> Void)?
    var onErrorOccured: ((SWError) -> Void)?
    var isWineLiked: Bool = false {
        didSet {
            guard let bitrix_id = bitrix_id else { return }
            guard let wine = wineService.obtainWine(by: bitrix_id) else { return }
            if (wine.isFavourite != isWineLiked) {
                wine.isFavourite = isWineLiked
                try? wine.managedObjectContext?.save()
//                try! self.cache.save(objects: [wine])
            }
            didWineLike?(wine)
        }
    }
    
    var nameTitle: String? {
        var nameStr = ""
        if let name = wine?.name {
            nameStr += name
        }
        if let volume = wine?.volume, volume != "0", volume != "" {
            nameStr += ", \(volume) л."
        }
        if let year = wine?.year, year > 0 {
            nameStr += ", \(year)"
        }
        if let name = wine?.russianName {
            nameStr += "\n\(name)"
        }
        return nameStr
    }
    
    var articleTitle: String? {
        return "\(wine?.article ?? "")".capitalized
    }
    
    var descriptionTitle: String? {
        return wine?.productDescription?.capitalized
    }
    
    var price: Int? {
        guard let price = wine?.hallPrice else { return nil }
        return Int(price)
    }
    
    private func updateWinePropertyItems() {
        winePropertyItems.removeAll()
        if let color = wine?.color {
            var wineColorImage: UIImage? = nil
            if color == "белое" { wineColorImage = UIImage(named: "WhiteColor") }
            else if color == "красное" { wineColorImage = UIImage(named: "RedColor") }
            else if color == "розовое" { wineColorImage = UIImage(named: "PinkColor") }
            let winePropertyItem = WinePropertyItem(wineProperty: .color, image: wineColorImage, value: color)
            winePropertyItems.append(winePropertyItem)
        }
        if let grapes = wine?.grapes {
            var grapeStr = grapes.joined(separator: ", ")
            let winePropertyItem = WinePropertyItem(wineProperty: .grapes, image: UIImage(named: "WineGrapes"), value: grapeStr)
            winePropertyItems.append(winePropertyItem)
        }
        if let sugar = wine?.sugar {
            let winePropertyItem = WinePropertyItem(wineProperty: .sugar, image: UIImage(named: "WineSugar"), value: sugar)
            winePropertyItems.append(winePropertyItem)
        }
        if let country = wine?.country {
            let winePropertyItem = WinePropertyItem(wineProperty: .country, image: countryFlagImage, value: country.name)
            winePropertyItems.append(winePropertyItem)
        }
    }
    
    var priceWithYourself: Int? {
        guard let price = wine?.price else { return nil }
        return Int(price)
    }
    
    private(set) var isActivityIndicatorAnimating: Bool {
        set {
            guard newValue != _isActivityIndicatorAnimating else { return }
            _isActivityIndicatorAnimating = newValue
            UI_THREAD { self.onAcitivityIndicatorStateChanged?() }
        }
        get {
            return _isActivityIndicatorAnimating
        }
    }
    
    init(
        authService: AuthService = AuthServiceImplementation(),
        bitrix_id: Int? = nil,
        isLiked: Bool = false,
        wineService: WineService = WineServiceImplementation(),
        imageService: ImageService = ImageServiceImplementation()
    ) {
        self.authService = authService
        self.wineService = wineService
        self.imageService = imageService
        guard let bitrix_id = bitrix_id else { return }
        isWineLiked = isLiked
        setBitrixId(bitrix_id: bitrix_id)
    }
    
    func setBitrixId(bitrix_id: Int) {
        self.bitrix_id = bitrix_id
        wine = wineService.obtainWine(by: bitrix_id)
        wineImage = obtainCachedWineImage()
        countryFlagImage = obtainCachedFlagImage()
        if wine == nil || wineImage == nil || countryFlagImage == nil {
            UI_THREAD {
                self.isActivityIndicatorAnimating = true
            }
            wineFetchTask = wineService.fetchWine(
                for: bitrix_id, token: authService.token!, deviceCode: authService.deviceCode!,
                onSuccess: { [weak self] (response, task, data) in
                    guard let sself = self, task?.state != .canceling else { return }
                    let oldWine = sself.wine ?? nil
                    
                    let dataStorage = ProductDetailDataStorage()
                    if let value = response?.value, let wine = dataStorage.insertNewObject(value) as? ProductDetail {
                        sself.wine = wine
                        if oldWine != nil {
                            sself.wine?.isFavourite = oldWine!.isFavourite
                        }
                        sself.loadWineImage()
                        sself.loadFlagImage()
                        sself.isActivityIndicatorAnimating = false
                        sself.isWineLiked = sself.wine?.isFavourite ?? false
                        sself.isLikedChanged?()
                    }
                },
                onFailure: { [weak self] (error: SWError, task: URLSessionTask?, data: Data?) in
                    guard let sself = self else { return }
                    guard let task = task, task.state != .canceling else { return }
                    sself.error = error
                }
            )
        }
        isWineLiked = wine?.isFavourite ?? false
        isLikedChanged?()
    }
    
    func close() {
        didClose?()
    }
    
    private func obtainCachedWineImage() -> UIImage? {
        guard let image = wine?.image,
            let article = wine?.article
        else {
            return nil
        }
        return imageService.image(for: image, id: "\(article)")
    }
    
    private func obtainCachedFlagImage() -> UIImage? {
        guard let countryModel = wine?.country,
              let country = wineService.obtainCountry(by: countryModel.name)
        else {
            return nil
        }
        return imageService.image(for: country.flag, id: countryModel.name)
    }
    
    func loadWineImage() {
        let cachedImage = obtainCachedWineImage()
        guard let article = wine?.article,
              let imageStr = wine?.image
        else {
            return
        }
        let staticURL = STATIC_URL ?? Config.contentBaseURL.absoluteString
        guard let url = URL(string: "\(staticURL)\(imageStr)")
            else {
                return
        }
        if cachedImage == nil {
            self.imageDownloadTask = self.imageService.downloadImage(
                url: url,
                id: article,
                completion: { [weak self] (image: UIImage?) in
                    guard let sself = self else { return }
                    guard let image = image else {
                        sself.wineImage = nil
                        return
                    }
                    sself.wineImage = image
                }
            )
        } else {
            wineImage = cachedImage
        }
    }
    
    func loadFlagImage() {
        let cachedImage = obtainCachedFlagImage()
        guard let countryPlain = wine?.country,
              let country = wineService.obtainCountry(by: countryPlain.name)
        else {
            return
        }
        let staticURL = STATIC_URL ?? Config.contentBaseURL.absoluteString
        guard let url = URL(string: "\(staticURL)\(country.flag)")
            else {
                return
        }
        if cachedImage == nil {
            flagImageDownloadTask = imageService.downloadImage(
                url: url,
                id: countryPlain.name,
                completion: { [weak self] (image: UIImage?) in
                    guard let sself = self else { return }
                    guard let image = image else {
                        sself.countryFlagImage = nil
                        return
                    }
                    sself.countryFlagImage = image
                }
            )
        } else {
            countryFlagImage = cachedImage
        }
    }
    
    deinit {
        imageDownloadTask?.cancel()
        wineFetchTask?.cancel()
    }
    
}
