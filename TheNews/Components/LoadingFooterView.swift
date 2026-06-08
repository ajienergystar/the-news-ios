//
//  LoadingFooterView.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class LoadingFooterView: UIView {

    private let indicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(indicator.prepareForAutoLayout())
        indicator.centerInSuperview()
        constrainSize(height: 44)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        indicator.startAnimating()
    }

    func stopAnimating() {
        indicator.stopAnimating()
    }
}
