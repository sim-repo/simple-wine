import UIKit

struct AppFont {
    
    private struct AppCustomFontNames {
        static let geometria = "Geometria"
    }
    
    // 500    Medium
    static func simpleMedium(ofSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: AppCustomFontNames.geometria, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
    
    static func charterBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "CharterITC-Bold", size: size)!
    }
    
    static func charterBoldItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "CharterITC-BoldItalic", size: size)!
    }
    
    static func charterRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "CharterITC", size: size)!
    }
    
    static func charterItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "CharterITC-Italic", size: size)!
    }
    
    static func geometriaRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Geometria", size: size)!
    }
    
    static func geometriaMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Geometria-Medium", size: size)!
    }
    
    static func geometriaLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Geometria-Light", size: size)!
    }
    
    static func simpleSemibold(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    /*
    // 100    Thin (Hairline)
    static func simpleThin(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .thin)
    }
    // 200    Extra Light (Ultra Light)
    static func simpleUltaLigth(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .ultraLight)
    }
    // 300    Light
    static func simpleLight(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .light)
    }
    // 400    Normal
    static func simpleRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    // 500    Medium
    static func simpleMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    // 700    Bold
    static func simpleBold(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    // 800    Extra Bold (Ultra Bold)
    static func simpleHeavy(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .heavy)
    }
    
    // 900    Black (Heavy)
    static func simpleBlack(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .black)
    }
 */
}
