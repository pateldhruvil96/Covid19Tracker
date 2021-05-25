//
//  CountryListsTableViewCell.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Patel on 5/22/21.
//

import UIKit

class CountryListsTableViewCell: UITableViewCell {

    //let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    private var task: URLSessionDataTask?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.countryFlagImageView.image = nil
        task?.cancel()
        task = nil
    }
        
    override func draw(_ rect: CGRect){
       // containerView.applyGradient(colors: [UIColor(hexCode: "#f1c40f").cgColor,UIColor(hexCode: "#ecf0f1").cgColor], locations: nil, direction: .topToBottom,cornerRadius: 20)
        sepratorView.layer.cornerRadius = 10
        countryFlagImageView.layer.cornerRadius = 20
//        countryFlagImageView.layer.shadowColor = UIColor.black.cgColor
//        countryFlagImageView.layer.shadowOffset = CGSize(width: 0.5, height: 4)
//        countryFlagImageView.layer.shadowOpacity = 0.5
//        countryFlagImageView.layer.shadowRadius = 8.0
    }
    func configureWith(urlString: String,saveAsCache:Bool) {
        if task == nil {
            // Ignore calls when reloading
            task = countryFlagImageView.downloadImage(from: urlString, saveAsCache: saveAsCache)
        }
    }


}
