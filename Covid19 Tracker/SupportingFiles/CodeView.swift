//
//  CodeView.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 23/05/21.
//

protocol CodeView {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupViews()
}

extension CodeView {
    func setupViews() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}

