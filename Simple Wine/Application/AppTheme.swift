//
//  Theme.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 02/07/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import Foundation
import UIKit

enum ThemeType: String {
    case grandcru
    case kuznetsky
    case depo
    
    func logo() -> UIImage? {
        switch self {
        case .grandcru:
            return UIImage(named: "logo_gc")
        case .depo:
            return UIImage(named: "logo_sw_depo")
        case .kuznetsky:
            return UIImage(named: "logo_sw_kuznetsky")
        }
    }
}

struct AppTheme {
    
    static var theme: ThemeType = .grandcru {
        didSet {
            UserDefaults.standard.setValue(theme.rawValue, forKey: Constants.UserDefaults.currentTheme)
            
            switch theme {
            case .kuznetsky, .depo:
                AppTheme.themeStruct = AppColor.Simplewine()
            case .grandcru:
                AppTheme.themeStruct = AppColor.Grandcru()
            }
        }
    }
    
    private static var themeStruct: AppColorProtocol =
        AppTheme.theme == .grandcru ? AppColor.Grandcru() : AppColor.Simplewine()
    
    
    static var background: UIColor { return AppTheme.themeStruct.background }
    static var navbarBackground: UIColor { return AppTheme.themeStruct.navbarBackground }
    static var tint: UIColor { return AppTheme.themeStruct.tint }
    static var line: UIColor { return AppTheme.themeStruct.line }
    static var selected: UIColor { return AppTheme.themeStruct.selected }
    static var highlighted: UIColor { return AppTheme.themeStruct.highlighted }
    static var error: UIColor { return AppTheme.themeStruct.error }
    static var unselected: UIColor { return AppTheme.themeStruct.unselected }
    static var lightGray: UIColor { return AppTheme.themeStruct.lightGray }
    static var darkGray: UIColor { return AppTheme.themeStruct.darkGray }
    static var textFieldText: UIColor { return AppTheme.themeStruct.textFieldText }
    static var textFieldBackground: UIColor { return AppTheme.themeStruct.textFieldBackground }
    static var textFieldPlaceholder: UIColor { return AppTheme.themeStruct.textFieldPlaceholder }
    static var textFieldInvalid: UIColor { return AppTheme.themeStruct.textFieldInvalid }
    
    static var menuCoverBorderColor: UIColor { return AppTheme.themeStruct.menuCoverBorderColor }
    
    static var logo: UIImage {
        switch AppTheme.theme {
        case .grandcru:
            return UIImage(named: "logo_gc") ?? UIImage()
        case .kuznetsky:
            return UIImage(named: "logo_sw_kuznetsky") ?? UIImage()
        case .depo:
            return UIImage(named: "logo_sw_depo") ?? UIImage()
        }
    }
    
    static var coverBackground: UIImage {
        switch AppTheme.theme {
        case .grandcru:
            return UIImage(named: "background_cover_gc") ?? UIImage()
        case .kuznetsky:
            return UIImage(named: "background_cover_sw_kuznetsky") ?? UIImage()
        case .depo:
            return UIImage(named: "background_cover_sw_depo") ?? UIImage()
        }
    }
    
    static var menuCoverView: MenuCoverView {
        switch AppTheme.theme {
        case .grandcru:
            return GrandCruMenuCover.fromXib()
        case .kuznetsky:
            return KuznetskyMenuCover.fromXib()
        case .depo:
            return DepoMenuCover.fromXib()
        }
    }
}
