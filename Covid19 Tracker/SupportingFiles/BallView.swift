//
//  BallView.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 23/05/21.
//

import UIKit

final class BallView: SpaceView {
    init(color: UIColor, space: CGFloat) {
        super.init(space: space)
        self.backgroundColor = color
        self.layer.cornerRadius = space / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
