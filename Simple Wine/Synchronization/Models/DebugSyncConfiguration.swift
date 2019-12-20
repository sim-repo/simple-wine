import UIKit

struct DebugSyncConfiguration: SyncConfiguration {
    var startTime: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
    
    var endTime: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date.tomorrow)!
    }
    
    var interval: TimeInterval {
        return 3600 // every hour
    }
}
