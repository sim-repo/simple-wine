import Foundation

func UI_THREAD(_ block: @escaping (() -> Void)) {
    DispatchQueue.main.async(execute: block)
}
