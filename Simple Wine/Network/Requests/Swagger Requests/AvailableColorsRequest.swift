import Foundation

final class AvailableColorsRequest: BaseWineshopRequest<[String]> {
    
    override var path: String {
        return "stores/\(self.vinothequeID)/color/"
    }
    
}
