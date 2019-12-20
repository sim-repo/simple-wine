import Foundation

protocol DetailWineModuleInput {
    func setBitrixId(bitrix_id: Int)
    var didWineLike: ((ProductDetail) -> Void)? { get set }
    var didClose: (() -> Void)? { get set }
}
