import Foundation
import UIKit

protocol WineTypesModuleInput {
    var heightForView: CGFloat { get }
    var didResizeView: (() -> Void)? { get set }
    var didCategorySelect: ((Category, UInt) -> Void)? { get set }
    func loadWineTypes(for category:Category)
    func selectFirst()
}
