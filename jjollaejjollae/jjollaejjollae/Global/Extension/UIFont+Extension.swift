//
//  UIFont+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/07/30.
//

import UIKit

struct AppFontName {
    static let bold = "RobotoMonoforPowerline-Bold"
    static let boldItalic = "RobotoMonoforPowerline-BoldItalic"
    static let regular = "RobotoMonoforPowerline-Regular"
    static let regularItalic = "RobotoMonoforPowerline-Italic"
    static let light = "RobotoMonoforPowerline-Light"
    static let lightItalic = "RobotoMonoforPowerline-LightItalic"
    static let medium = "RobotoMonoforPowerline-Medium"
    static let mediumItalic = "RobotoMonoforPowerline-MediumItalic"
    static let thin = "RobotoMonoforPowerline-Thin"
    static let thinItalic = "RobotoMonoforPowerline-ThinItalic"
}

/*
Family: Spoqa Han Sans Neo Font names: ["SpoqaHanSansNeo-Thin", "SpoqaHanSansNeo-Regular", "SpoqaHanSansNeo-Light", "SpoqaHanSansNeo-Medium", "SpoqaHanSansNeo-Bold"]
*/

fileprivate struct HanSansNeoFont {
  
  static let bold = "SpoqaHanSansNeo-Bold"
  static let regular = "SpoqaHanSansNeo-Regular"
  static let thin = "SpoqaHanSansNeo-Thin"
  static let light = "SpoqaHanSansNeo-Light"
  static let medium = "SpoqaHanSansNeo-Medium"
}



extension UIFont {
  
  /*
   Spoqa Han Sans Neo
   */
  
  static func hanSansNeoBold(size: CGFloat) -> UIFont {
    return UIFont(name:HanSansNeoFont.bold, size: size)!
  }
  
  static func hanSansNeoRegular(size: CGFloat) -> UIFont {
    return UIFont(name:HanSansNeoFont.regular, size: size)!
  }
  
  static func hanSansNeoThin(size: CGFloat) -> UIFont {
    return UIFont(name:HanSansNeoFont.thin, size: size)!
  }
  
  static func hanSansNeoLight(size: CGFloat) -> UIFont {
    return UIFont(name:HanSansNeoFont.light, size: size)!
  }
  
  static func hanSansNeoMedium(size: CGFloat) -> UIFont {
    return UIFont(name:HanSansNeoFont.medium, size: size)!
  }

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
