//
//  SpaceView.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 23/05/21.
//

import UIKit

class SpaceView: UIView {
    private let space: CGFloat

    override var intrinsicContentSize: CGSize {
        return CGSize(width: space, height: space)
    }

    init(space: CGFloat) {
        self.space = space
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
