import SwiftEntryKit

class ToastView {
    static func showError(error: SWError) {
        var title = EKProperty.LabelContent(text: error.title, style: .init(font: UIFont.boldSystemFont(ofSize: 14), color: .red))
        title.style.alignment = .center
        
        var description = EKProperty.LabelContent(text: error.message, style: .init(font: UIFont.systemFont(ofSize: 14), color: .black))
        description.style.alignment = .center
        
        let simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
        let entry = EKNotificationMessageView(with: EKNotificationMessage(simpleMessage: simpleMessage))
        
        var attributes = EKAttributes()
        attributes.entryBackground = .color(color: .white)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.5), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.75, radius: 4, offset: .zero))
        attributes.position = .bottom
        attributes.displayDuration = 5
        
        SwiftEntryKit.display(entry: entry, using: attributes)
    }
}
