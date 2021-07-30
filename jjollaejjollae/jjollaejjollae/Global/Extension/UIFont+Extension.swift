//
//  UIFont+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/07/30.
//

import UIKit

struct AppFontName {
    static let bold = "Roboto Mono Bold for Powerline"
    static let boldItalic = "Roboto Mono Bold Italic for Powerline"
    static let regular = "Roboto Mono for Powerline"
    static let regularItalic = "Roboto Mono Italic for Powerline"
    static let light = "Roboto Mono Light for Powerline"
    static let lightItalic = "Roboto Mono Light Italic for Powerline"
    static let medium = "Roboto Mono Medium for Powerline"
    static let mediumItalic = "Roboto Mono Medium Italic for Powerline"
    static let thin = "Roboto Mono Thin for Powerline"
    static let thinItalic = "Roboto Mono Thin Italic for Powerline"
}

extension UIFont {
    //MARK: - Roboto
    class func robotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    class func robotoBoldItalic(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.boldItalic, size: size)!
    }
    
    class func robotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    class func robotoRegularItalic(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regularItalic, size: size)!
    }
    
    class func robotoLight(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.light, size: size)!
    }
    
    class func robotoLightItalic(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.lightItalic, size: size)!
    }
    
    class func robotoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.medium, size: size)!
    }
    
    class func robotoMediumItalic(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.mediumItalic, size: size)!
    }
    
    class func robotoThin(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.thin, size: size)!
    }
    
    class func robotoThinItalic(size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.thinItalic, size: size)!
    }

}
