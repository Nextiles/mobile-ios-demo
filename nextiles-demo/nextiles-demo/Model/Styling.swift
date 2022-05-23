//
//  Styling.swift
//  nextiles-demo
//
//  Created by Work on 5/17/22.
//

import Foundation
import UIKit
import SwiftUI
class Styling {
    
    //get the logo image
    static func getLogo () -> Image{
        return Image("logo")
    }
    
    static var compilerBackgroundColor = LinearGradient(
        colors: [
            Color(red: 0.358, green: 0.358, blue: 0.358),
            Color(red: 0.117, green: 0.11, blue: 0.11)
                ],
        startPoint: .top,
        endPoint: .bottom)
    
    struct Fonts {
            static let display01: Font = Font.custom("NasalizationRg-Regular", size: 32)
            static let headline01: Font = Font.custom("GreycliffCF-Bold", size: 22)
            static let headline02: Font = Font.custom("GreycliffCF-DemiBold", size: 18)
            static let headline03: Font = Font.custom("GreycliffCF-DemiBold", size: 16)
            static let button: Font = Font.custom("GreycliffCF-Bold", size: 16)
            static let body01: Font = Font.custom("GreycliffCF-Regular", size: 14)
            static let body02: Font = Font.custom("GreycliffCF-Regular", size: 12)
        }  
}
