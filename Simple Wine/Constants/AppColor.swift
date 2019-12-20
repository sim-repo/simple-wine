import UIKit

protocol AppColorProtocol {
    var background: UIColor {get}
    var navbarBackground: UIColor {get}
    var tint: UIColor {get}
    var line: UIColor {get}
    
    var selected: UIColor {get}
    var unselected: UIColor {get}
    var highlighted: UIColor {get}
    
    var lightGray: UIColor {get}
    var darkGray: UIColor {get}
    var error: UIColor {get}
    
    var textFieldText: UIColor {get}
    var textFieldPlaceholder: UIColor {get}
    var textFieldBackground: UIColor {get}
    var textFieldInvalid: UIColor {get}
    
    var menuCoverBorderColor: UIColor {get}
}

struct AppColor {

    struct Simplewine: AppColorProtocol {
        var background = UIColor.rgba(233,232,226,1)
        var navbarBackground = UIColor.rgba(233,232,226,1) //UIColor.rgba(240,240,240,1)
        var tint = UIColor.rgba(164, 32, 63)
        var line = UIColor(r: 113, g: 115, b: 117) //UIColor(r: 180, g: 180, b: 177)
        
        var selected = UIColor.rgba(164, 32, 63)
        var unselected = UIColor.rgba(64, 64, 64)
        var highlighted = UIColor.rgba(164, 32, 63)
        
        var lightGray = UIColor.rgba(151, 151, 151)
        var darkGray = UIColor.rgba(77, 77, 79)
        var error = UIColor.rgba(164, 32, 63)
        
        var textFieldText = UIColor.rgba(43, 43, 43, 1)
        var textFieldPlaceholder = UIColor.rgba(138, 138, 138)
        var textFieldBackground = UIColor.rgba(222, 221, 214, 1)
        var textFieldInvalid = UIColor.rgba(167,33,68,1)
        
        var menuCoverBorderColor = UIColor.rgba(142, 39, 64, 100)
    }
    
    struct Grandcru: AppColorProtocol {
        var background = UIColor.white
        var navbarBackground = UIColor.white
        var tint = UIColor.rgba(139, 113, 102)
        var line = UIColor(r: 139, g: 113, b: 102)
        
        var selected = UIColor.rgba(139, 113, 102)
        var unselected = UIColor.rgba(64, 64, 64)
        var highlighted = UIColor.black
        
        var lightGray = UIColor.rgba(151, 151, 151)
        var darkGray = UIColor.rgba(77, 77, 79)
        var error = UIColor.rgba(164, 32, 63)
        
        var textFieldText = UIColor.rgba(43, 43, 43, 1)
        var textFieldPlaceholder = UIColor.rgba(138, 138, 138)
        var textFieldBackground = UIColor.rgba(222, 221, 214, 1)
        var textFieldInvalid = UIColor.rgba(167,33,68,1)
        
        var menuCoverBorderColor = UIColor.rgba(151, 105, 52, 100)
    }
    
}
