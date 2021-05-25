//
//  LoadingOverlay.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 25/05/21.
//

import Foundation
import UIKit

public class LoadingOverlay{
    
    var activityIndicator : UIActivityIndicatorView!
    var mainView : UIView!
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    init(){
        self.activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .white
    }
    
    public func showOverlay(view: UIView) {
        DispatchQueue.main.async {
            self.mainView = UIView()
            self.mainView.frame = UIScreen.main.bounds
            self.mainView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            self.activityIndicator.center = view.center
            self.mainView.addSubview(self.activityIndicator)
            view.addSubview(self.mainView)
            self.activityIndicator.startAnimating()
        }
    }
    
    public func hideOverlayView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.mainView.removeFromSuperview()
        }
        
    }
}
