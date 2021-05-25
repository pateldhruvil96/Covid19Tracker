//
//  Font.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 25/05/21.
//

import UIKit

enum Font {
    static func regular(size: CGFloat) -> UIFont {
        let fontName = "Nunito-Regular"
        guard let font = UIFont(name: fontName, size: size) else {
            fatalError("""
                Failed to load the "\(fontName)" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        return font
    }

    static func light(size: CGFloat) -> UIFont {
        let fontName = "Nunito-Light"
        guard let font = UIFont(name: fontName, size: size) else {
            fatalError("""
                Failed to load the "\(fontName)" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        return font
    }

    static func bold(size: CGFloat) -> UIFont {
        let fontName = "Nunito-Bold"
        guard let font = UIFont(name: fontName, size: size) else {
            fatalError("""
                Failed to load the "\(fontName)" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        return font
    }

    static func semiBold(size: CGFloat) -> UIFont {
        let fontName = "Nunito-SemiBold"
        guard let font = UIFont(name: fontName, size: size) else {
            fatalError("""
                Failed to load the "\(fontName)" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        return font
    }
}
