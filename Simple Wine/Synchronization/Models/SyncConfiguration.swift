import Foundation

protocol SyncConfiguration {
    var startTime: Date { get }
    var endTime: Date { get }
    var interval: TimeInterval { get }
}
